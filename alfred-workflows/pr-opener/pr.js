ObjC.import("Foundation");

function env(name) {
  const value = $.NSProcessInfo.processInfo.environment.objectForKey(name);
  return value.isNil() ? "" : value.js.trim();
}

function clipboard() {
  try {
    const app = Application.currentApplication();
    app.includeStandardAdditions = true;
    return app.theClipboard() || "";
  } catch (_) {
    return "";
  }
}

function findRefs(text, defaultOrg) {
  const refs = [];
  const seen = new Set();
  const add = (org, repo, num) => {
    const key = `${org}/${repo}#${num}`.toLowerCase();
    if (seen.has(key)) return;
    seen.add(key);
    refs.push({ org, repo, num });
  };

  const urlRe = /github\.com\/([\w.-]+)\/([\w.-]+)\/(?:pull|issues)\/(\d+)/g;
  let m;
  while ((m = urlRe.exec(text))) add(m[1], m[2], m[3]);

  const withoutUrls = text.replace(/https?:\/\/\S+/g, " ");
  const refRe = /(?:^|[^\w./-])(?:([\w.-]+)\/)?([\w.-]+)#(\d+)\b/g;
  while ((m = refRe.exec(withoutUrls))) {
    const org = m[1] || defaultOrg;
    if (org) add(org, m[2], m[3]);
  }
  return refs;
}

function run(argv) {
  const defaultOrg = env("default_org");
  let text = (argv[0] || "").trim();
  const fromClipboard = text === "";
  if (fromClipboard) text = clipboard();

  const items = findRefs(text, defaultOrg).map(({ org, repo, num }) => {
    const url = `https://github.com/${org}/${repo}/pull/${num}`;
    return {
      uid: url,
      title: `${org}/${repo}#${num}`,
      subtitle: url,
      arg: url,
      quicklookurl: url,
      text: { copy: url, largetype: url },
      mods: { cmd: { arg: url, subtitle: "Copy URL" } },
    };
  });

  if (items.length === 0) {
    const hint = defaultOrg
      ? "Try repo#123, org/repo#123 or a GitHub PR URL"
      : "Set default_org in the workflow configuration to use bare repo#123";
    items.push({
      title: fromClipboard ? "No PR reference on the clipboard" : `No PR reference in "${text}"`,
      subtitle: hint,
      valid: false,
    });
  }

  return JSON.stringify({ items });
}
