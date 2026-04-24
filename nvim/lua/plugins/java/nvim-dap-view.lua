return {
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    version = "1.*",
    opts = {
      winbar = {
        -- 在这里定义你想要显示的板块及其顺序
        sections = {
          "watches",
          "scopes",
          "exceptions",
          "breakpoints",
          "threads",
          "repl",
          "console",
        },
        -- 设置默认选中的板块
        default_section = "scopes",
      },
    },
  },
}
