local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node

-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")

local extras = require("luasnip.extras")
-- local l = extras.lambda
local rep = extras.rep -- repeats the content of the `number` insert node referenced
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

local function iterable_vars()
  -- TODO - if possible, filter by iterable type - moliva - 2024/04/03
  local function_node_types = {
    function_declaration = true,
    function_expression = true,
    arrow_function = true,
  }

  local node = vim.treesitter.get_node()
  while node ~= nil do
    if function_node_types[node:type()] then
      break
    end

    node = node:parent()
  end

  if not node then
    vim.notify("Not inside of a function")

    return t("")
  end

  local query = assert(vim.treesitter.query.get("typescript", "vars-in-scope"), "No query")

  local fields = {}

  local has_choices = false
  for _, each, _, _ in query:iter_captures(node, 0) do
    local text = vim.treesitter.get_node_text(each, 0)

    -- check if field is already in table, as the query retrieves dups
    if fields[text] == nil then
      fields[text] = t(text)
      has_choices = true
    end
  end

  if has_choices then
    return { c(1, vim.tbl_values(fields)) }
  else
    return i(1, "iterable")
  end
end

local function iterables(args)
  return sn(
    nil, -- position for this node, which can be determined by caller
    iterable_vars()
  )
end

local function setterName(args)
  local function setter(name)
    return t("set" .. name:gsub("^%l", string.upper))
  end

  return sn(
    nil, -- position for this node, which can be determined by caller
    setter(args[1][1])
  )
end

return {
  parse("plog", 'console.log("${1:expression}", $1);'),
  parse("log", "console.log('${1:expression}', $1)"),
  s(
    "forconst",
    fmta(
      [[for (const <item> of <iterable>) {
  <finish>
}]],
      {
        item = i(1, "each"),
        iterable = d(2, iterables, {}),
        finish = i(0),
      }
    )
  ),
  s(
    "forlet",
    fmt("for (let {} = {}; {} < {}; ++{}) {{\n  {}\n}}", {
      i(1, "i"),
      i(2, "0"),
      rep(1),
      i(3, "array.length"), -- TODO - lookup options from context - moliva - 2024/04/01
      rep(1),
      i(0),
    })
  ),
  s(
    "itfn",
    fmt('{}{}("{}", {}() => {{\n  {}\n}})', {
      c(1, { t("it"), t("describe") }),
      c(2, { t(""), t(".only"), t(".ignore") }),
      i(3, "test name"),
      c(4, { t(""), t("async ") }),
      i(0),
    })
  ),
  s(
    "signal",
    fmta("const [<signal>, <setSignal>] = createSignal<type>(<initialValue>)\n<finish>", {
      signal = i(1, "name"),
      setSignal = d(2, setterName, { 1 }),
      -- type = c(3, { t(""), fmt("<{}>", { i(0, "generic") }) }),
      type = i(3),
      initialValue = i(4, "initialValue"),
      finish = i(0),
    })
  ),
}
