local ls = require("luasnip")

local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
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
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

return {
  parse(
    "sep",
    "$LINE_COMMENT *****************************************************************************************************\n$LINE_COMMENT *************** ${1:separator} ***************\n$LINE_COMMENT *****************************************************************************************************\n"
  ),
  parse(
    "todo",
    "$LINE_COMMENT ${1|TODO,NOTE,FIXME,XXX|} - ${2:description} - moliva - $CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"
  ),
  parse(
    "btodo",
    "$LINE_COMMENT ${1|TODO,NOTE,FIXME,XXX|}(miguel): ${2:description} - $CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"
  ),
  -- s("todo1", fmt("{} {} - {} - moliva - {}", { t("//"), c(1, { t("TODO"), t("FIXME"), t("XXX") }), i(2, "description"), f(function()
  --   return
  --       os.date("%Y/%m/%d")
  -- end) })),
}
