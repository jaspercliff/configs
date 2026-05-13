return {
  -- "jaspercliff/java-helper.nvim",
  dir = vim.fn.expand("~/code/lua/java-helper.nvim"),
  config = function()
    require("java-helper").setup({
      create_class_command = "JavaCreateClass",
      author = "jasper",
      -- since_format = "%Y-%m-%d %H:%M:%S",
      since_format = "%Y-%m-%d",
      sub_package = "com.jasper",
    })
  end,
  keys = {
    {
      "<leader>jt",
      "<Cmd>JavaGoToTest<CR>",
      desc = "Java 跳转到测试类/源文件",
      ft = "java", -- 可选：限制只在打开 java 文件时快捷键生效
    },
    {
      "<leader>jt",
      "<Cmd>JavaGoToTest<CR>",
      desc = "Java 跳转到测试类/源文件",
      ft = "java",
    },
    {
      "<leader>jm",
      "<Cmd>JavaGoToMapper<CR>",
      desc = "Java Mapper ↔ XML 双向跳转",
      ft = "java,xml",
    },
  },
}
