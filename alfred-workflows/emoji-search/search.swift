// Emoji search for Alfred. Build with ./build.sh
//
//   emoji-search <query...>      print Alfred script filter JSON
//   emoji-search --record <e>    bump usage count for an emoji (frecency boost)

import Foundation

let maxResults = 60
let toneNames = ["light": 1, "medium-light": 2, "medium": 3, "medium-dark": 4, "dark": 5]

struct Emoji {
    let emoji: String
    let label: String
    var names: [String]
    let codes: [String]
    var keywords: [String]
    let categories: [String]
    let skins: [String]
    let order: Int
    var haystack: [UInt8]  // all search columns, for a cheap substring pre-filter
}

// MARK: - helpers

func normalize(_ s: String) -> String {
    let folded = s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        .replacingOccurrences(of: "’", with: "").replacingOccurrences(of: "'", with: "")
    var out = "", space = false
    for c in folded.unicodeScalars {
        if (c >= "a" && c <= "z") || (c >= "0" && c <= "9") || c == "+" {
            if space && !out.isEmpty { out.append(" ") }
            out.unicodeScalars.append(c)
            space = false
        } else {
            space = true
        }
    }
    return out
}

func stripVS(_ s: String) -> String { s.replacingOccurrences(of: "\u{FE0F}", with: "") }

func contains(_ hay: [UInt8], _ needle: [UInt8]) -> Bool {
    guard let first = needle.first, needle.count <= hay.count else { return needle.isEmpty }
    var i = 0
    let last = hay.count - needle.count
    while i <= last {
        if hay[i] == first {
            var j = 1
            while j < needle.count && hay[i + j] == needle[j] { j += 1 }
            if j == needle.count { return true }
        }
        i += 1
    }
    return false
}

/// Edit distance counting a swap of adjacent letters ("rokcet") as one edit.
func editDistance(_ a: [Character], _ b: [Character]) -> Int {
    if a.isEmpty { return b.count }
    if b.isEmpty { return a.count }
    var d = [[Int]](repeating: [Int](repeating: 0, count: b.count + 1), count: a.count + 1)
    for i in 0...a.count { d[i][0] = i }
    for j in 0...b.count { d[0][j] = j }
    for i in 1...a.count {
        for j in 1...b.count {
            d[i][j] = min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1))
            if i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1] {
                d[i][j] = min(d[i][j], d[i - 2][j - 2] + 1)
            }
        }
    }
    return d[a.count][b.count]
}

let env = ProcessInfo.processInfo.environment
let workflowDir = URL(fileURLWithPath: CommandLine.arguments[0]).resolvingSymlinksInPath().deletingLastPathComponent()
let dataDir = URL(fileURLWithPath: env["alfred_workflow_data"]
    ?? (NSHomeDirectory() + "/Library/Application Support/Alfred/Workflow Data/emoji-search"))
let usageFile = dataDir.appendingPathComponent("usage.tsv")

// MARK: - loading

/// Parsed at the byte level: Character-based splitting of the whole file costs ~20ms per keystroke.
func loadIndex() -> [Emoji] {
    guard let data = FileManager.default.contents(atPath: workflowDir.appendingPathComponent("emojis.tsv").path) else { return [] }
    let bytes = [UInt8](data)
    func str(_ s: ArraySlice<UInt8>) -> String { String(decoding: s, as: UTF8.self) }
    func list(_ s: ArraySlice<UInt8>, _ sep: UInt8) -> [String] {
        s.isEmpty ? [] : s.split(separator: sep, omittingEmptySubsequences: false).map(str)
    }
    var out: [Emoji] = []
    out.reserveCapacity(2000)
    for line in bytes.split(separator: 0x0A) {
        let c = line.split(separator: 0x09, omittingEmptySubsequences: false)
        guard c.count >= 7 else { continue }
        out.append(Emoji(emoji: str(c[0]), label: str(c[1]), names: list(c[2], 0x7C), codes: list(c[3], 0x7C),
                         keywords: list(c[4], 0x7C), categories: list(c[5], 0x7C), skins: list(c[6], 0x2C),
                         order: out.count, haystack: Array(line[c[2].startIndex..<c[5].endIndex])))
    }
    return out
}

/// synonyms.txt lines: `<emoji or :shortcode:> word, another phrase, ...` (# for comments)
func applySynonyms(_ emojis: inout [Emoji]) {
    guard let text = try? String(contentsOf: workflowDir.appendingPathComponent("synonyms.txt"), encoding: .utf8) else { return }
    var byEmoji: [String: Int] = [:], byCode: [String: Int] = [:]
    for (i, e) in emojis.enumerated() {
        byEmoji[stripVS(e.emoji)] = i
        for s in e.skins where !s.isEmpty { byEmoji[stripVS(s)] = i }
        for c in e.codes where byCode[c] == nil { byCode[c] = i }
    }
    for raw in text.split(separator: "\n") {
        let line = raw.trimmingCharacters(in: .whitespaces)
        guard !line.isEmpty, !line.hasPrefix("#"), let space = line.firstIndex(where: { $0 == " " || $0 == "\t" }) else { continue }
        let key = String(line[..<space])
        let idx = key.hasPrefix(":") ? byCode[normalize(key)] : byEmoji[stripVS(key)]
        guard let i = idx else { continue }
        let words = line[space...].split(separator: ",").map { normalize(String($0)) }.filter { !$0.isEmpty }
        emojis[i].names += words  // user synonyms rank like the official name
        emojis[i].haystack += Array(("|" + words.joined(separator: "|")).utf8)
    }
}

func loadUsage() -> [String: Double] {
    guard let text = try? String(contentsOf: usageFile, encoding: .utf8) else { return [:] }
    var out: [String: Double] = [:]
    for line in text.split(separator: "\n") {
        let c = line.split(separator: "\t")
        if c.count >= 2, let n = Double(c[1]) { out[String(c[0])] = n }
    }
    return out
}

// MARK: - scoring

struct Field { let terms: [String]; let weight: Double }

/// Best score for one query token against a list of phrases.
func tokenScore(_ t: String, _ terms: [String], fuzzy: Bool) -> Double {
    var best = 0.0
    for term in terms {
        if term == t { return 100 }
        if term.hasPrefix(t) { best = max(best, 80); continue }
        for w in term.split(separator: " ") {
            if w == t { best = max(best, 75) } else if w.hasPrefix(t) { best = max(best, 60) }
        }
        if best < 25 && t.count >= 3 && term.contains(t) { best = 25 }
        if fuzzy && best < 40 {
            let tc = Array(t), limit = t.count >= 7 ? 2 : 1
            for w in term.split(separator: " ") where abs(w.count - t.count) <= limit {
                if editDistance(tc, Array(w)) <= limit { best = max(best, 40); break }
            }
        }
    }
    return best
}

func score(_ e: Emoji, query: String, tokens: [String], fuzzy: Bool) -> Double {
    if !fuzzy && !tokens.allSatisfy({ contains(e.haystack, Array($0.utf8)) }) { return 0 }
    let fields = [Field(terms: e.names, weight: 1.0), Field(terms: e.codes, weight: 0.95),
                  Field(terms: e.keywords, weight: 0.75), Field(terms: e.categories, weight: 0.3)]
    var total = 0.0
    for t in tokens {
        var best = 0.0
        for f in fields { best = max(best, tokenScore(t, f.terms, fuzzy: fuzzy) * f.weight) }
        if best == 0 { return 0 }
        total += best
    }
    if e.names.contains(query) || e.codes.contains(query) { total += 120 }
    else if e.names.contains(where: { $0.hasPrefix(query) }) { total += 50 }
    // prefer short, specific names ("fire" over "fire extinguisher")
    return total - Double(e.names.first?.count ?? 0) * 0.3
}

// MARK: - output

func display(_ e: Emoji, tone: Int) -> String {
    tone > 0 && e.skins.count >= tone && !e.skins[tone - 1].isEmpty ? e.skins[tone - 1] : e.emoji
}

func item(_ e: Emoji, tone: Int) -> [String: Any] {
    let emoji = display(e, tone: tone)
    let code = e.codes.first.map { ":" + $0.replacingOccurrences(of: " ", with: "_") + ":" }
    var details: [String] = []
    if let code = code { details.append(code) }
    let extras = (e.names.dropFirst() + e.keywords).prefix(8)
    if !extras.isEmpty { details.append(extras.joined(separator: ", ")) }
    var mods: [String: Any] = ["cmd": ["arg": emoji, "subtitle": "Paste \(emoji) into the frontmost app"]]
    mods["alt"] = code.map { ["arg": $0, "subtitle": "Copy shortcode \($0)"] } ?? ["valid": false, "subtitle": "No shortcode"]
    return [
        "title": "\(emoji)  \(e.label)",
        "subtitle": details.joined(separator: "  ·  "),
        "arg": emoji,
        "text": ["copy": emoji, "largetype": emoji],
        "icon": ["path": "icon.png"],
        "mods": mods,
    ]
}

func emit(_ items: [[String: Any]]) {
    let payload: [String: Any] = ["skipknowledge": true, "items": items]
    let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
    FileHandle.standardOutput.write(data)
}

// MARK: - commands

func record(_ value: String, index: [Emoji]) {
    let key = stripVS(value)
    let base = index.first { stripVS($0.emoji) == key || $0.skins.contains { stripVS($0) == key } }?.emoji ?? value
    var usage = loadUsage()
    usage[base, default: 0] += 1
    try? FileManager.default.createDirectory(at: dataDir, withIntermediateDirectories: true)
    let text = usage.map { "\($0.key)\t\(Int($0.value))" }.joined(separator: "\n") + "\n"
    try? text.write(to: usageFile, atomically: true, encoding: .utf8)
}

func search(_ raw: String, index: [Emoji]) {
    let tone = toneNames[(env["SKIN_TONE"] ?? "").lowercased()] ?? 0
    let usage = loadUsage()
    let query = normalize(raw)

    if query.isEmpty {
        // Reverse lookup when an emoji is typed/pasted, otherwise show most used
        let key = stripVS(raw.trimmingCharacters(in: .whitespaces))
        if !key.isEmpty, let e = index.first(where: { stripVS($0.emoji) == key || $0.skins.contains { stripVS($0) == key } }) {
            return emit([item(e, tone: tone)])
        }
        let top = index.filter { usage[$0.emoji] != nil }.sorted { usage[$0.emoji]! > usage[$1.emoji]! }
        let items = (top.isEmpty ? Array(index.prefix(maxResults)) : Array(top.prefix(maxResults))).map { item($0, tone: tone) }
        return emit(items)
    }

    let tokens = query.split(separator: " ").map(String.init)
    var results: [(Double, Emoji)] = []
    for fuzzy in [false, true] {
        for e in index {
            var s = score(e, query: query, tokens: tokens, fuzzy: fuzzy)
            if s <= 0 { continue }
            if let n = usage[e.emoji] { s += min(40, 10 * log2(1 + n)) }
            results.append((s, e))
        }
        if !results.isEmpty { break }  // only fall back to typo matching when nothing matched
    }
    results.sort { $0.0 != $1.0 ? $0.0 > $1.0 : $0.1.order < $1.1.order }

    var items = results.prefix(maxResults).map { item($0.1, tone: tone) }
    if items.isEmpty {
        items = [["title": "No emoji found for “\(raw)”", "subtitle": "Add your own words in synonyms.txt", "valid": false]]
    }
    emit(items)
}

var index = loadIndex()
applySynonyms(&index)

let args = Array(CommandLine.arguments.dropFirst())
if args.first == "--record" {
    if args.count > 1 { record(args[1], index: index) }
} else {
    search(args.joined(separator: " "), index: index)
}
