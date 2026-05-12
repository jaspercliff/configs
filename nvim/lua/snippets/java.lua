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
  -- 倒序 for
  s({
    trig = "([%w%._%(%)]+)%.forr",
    regTrig = true,
  }, {
    t("for (int i = "),
    f(function(_, snip)
      return snip.captures[1] .. " - 1"
    end),
    t({ "; i >= 0; i--) {", "\t" }),
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

-- 从上一行提取变量名

local function get_prev_var()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  if row <= 1 then
    return "var"
  end
  local line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1]
  if not line then
    return "var"
  end
  -- 匹配：String name = ...
  local var = line:match("(%w+)%s*=")
  if var then
    return var
  end
  return "var"
end

ls.add_snippets("java", {
  s({
    trig = "soutv",
  }, {
    t('System.out.println("'),
    f(function()
      return get_prev_var()
    end),
    t(' = " + '),
    f(function()
      return get_prev_var()
    end),
    t(");"),
  }),
})
