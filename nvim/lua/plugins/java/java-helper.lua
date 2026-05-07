return {
  {
    "jaspercliff/java-helper.nvim",
--    dir = vim.fn.expand("~/code/lua/java-helper.nvim"),
    config = function()
      require("java-helper").setup({
        create_class_command = "JavaCreateClass",
        author = "jasper",
        -- since_format = "%Y-%m-%d %H:%M:%S",
        since_format = "%Y-%m-%d",
        sub_package = "com.jasper",
      })
    end,
  },
}
