return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "rcasia/neotest-java",
    },
    config = function(_, opts)
      local neotest = require("neotest")
      ---@diagnostic disable-next-line: missing-fields
      neotest.setup({
        adapters = {
          require("neotest-java")({
            ignore_wrapper = false,
          }),
        },
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    keys = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java" })
      end
    end,
  },
}
