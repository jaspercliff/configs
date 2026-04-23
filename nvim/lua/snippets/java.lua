local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("java", {
  s({
    trig = "(%S+)%.if",
    regTrig = true,
  }, {
    t("if ("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t({ ") {", "\t" }),
    i(1),
    t({ "", "}" }),
  }),
})

ls.add_snippets("java", {
  s({
    trig = "(%S+)%.soutv",
    regTrig = true,
  }, {
    t('System.out.println("'),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(' = " + '),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(");"),
  }),
})

ls.add_snippets("java", {
  -- a.n  -> if (a == null)
  s({
    trig = "([%w%._%(%)]+)%.n",
    regTrig = true,
  }, {
    t("if ("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(" == null) {"),
    t({ "", "\t" }),
    i(1),
    t({ "", "}" }),
  }),
  -- a.nn -> if (a != null)
  s({
    trig = "([%w%._%(%)]+)%.nn",
    regTrig = true,
  }, {
    t("if ("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(" != null) {"),
    t({ "", "\t" }),
    i(1),
    t({ "", "}" }),
  }),

  s({
    trig = "([%w%._%(%)]+)%.not",
    regTrig = true,
  }, {
    t("if (!"),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t({ ") {", "\t" }),
    i(1),
    t({ "", "}" }),
  }),

  s({
    trig = "([%w%._%(%)]+)%.cast",
    regTrig = true,
  }, {
    t("(("),
    i(1, "Type"),
    t(") "),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(")"),
  }),
  s({
    trig = "([%w%._%(%)]+)%.log",
    regTrig = true,
  }, {
    t('log.info("'),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(' = {}", '),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(");"),
  }),
  s({
    trig = "([%w%._%(%)]+)%.for",
    regTrig = true,
  }, {
    t("for (int i = 0; i < "),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t({ "; i++) {", "\t" }),
    i(1),
    t({ "", "}" }),
  }),
  s({
    trig = "([%w%._%(%)]+)%.ret",
    regTrig = true,
  }, {
    t("return "),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(";"),
  }),
})
