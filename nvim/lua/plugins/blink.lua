return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = {
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            vim.schedule(function()
              ls.expand_or_jump()
            end)
            return true
          end
        end,
        "fallback",
      },
    },
  },
}
