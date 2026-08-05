return {
  -- "jaspercliff/java-helper.nvim",
  dir = vim.fn.expand("~/code/lua/java-helper.nvim"),
  ft = "java",
  cmd = {
    "JavaCreateClass",
    "JavaInitProject",
    "JavaGoToTest",
    "JavaGoToMapper",
    "JavaMapperHover",
  },
  opts = {
    create_class_command = "JavaCreateClass",
    author = "jasper",
    since_format = "%Y-%m-%d",
    sub_package = "com.jasper",
    auto_hover_mapper = true, -- 自动悬停开启
  },
  keys = {
    {
      "<leader>jt",
      "<Cmd>JavaGoToTest<CR>",
      desc = "Java 跳转到测试类/源文件",
      ft = "java", -- 可选：限制只在打开 java 文件时快捷键生效
    },
    {
      "<leader>jm",
      "<Cmd>JavaGoToMapper<CR>",
      desc = "Java Mapper ↔ XML 双向跳转",
      ft = { "java", "xml" },
    },
    --  1s 自动浮窗 当sql太长时，可以按该快捷键快速进去弹窗进行滚动查看
    {
      "<leader>jh",
      "<Cmd>JavaMapperHover<CR>",
      desc = "Java Mapper hover",
      ft = { "java" },
    },
    --  1s 自动浮窗 当sql太长时，可以按该快捷键快速进去弹窗进行滚动查看
    {
      "<leader>jp",
      "<Cmd>JavaPasteClass<CR>",
      desc = "Java: 粘贴代码并建类",
    },
    {
      "<leader>js",
      "<Cmd>JavaJvmSpec<CR>",
      desc = "Go to JVM Spec",
    },
    {
      "<leader>jd",
      "<Cmd>JavaGenJavadoc<CR>",
      desc = "generate java doc",
    },

    vim.keymap.set("n", "<leader>jp", "<cmd>JavaPropsYamlConvert<CR>", { desc = "YAML ↔ Props 互转" }),
  },
}
