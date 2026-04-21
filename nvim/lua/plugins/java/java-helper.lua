return {
  {
    -- "jaspercliff/java-helper.nvim",

    -- 本地调试：用本地路径
    dir = vim.fn.expand("~/code/lua/java-helper.nvim"),

    config = function()
      require("java-helper").setup()
    end,
  },
}
