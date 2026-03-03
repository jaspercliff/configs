return {
  {
    "mistweaverco/kulala.nvim",
    -- 仅在打开 .http 或 .rest 文件时加载插件，优化启动速度
    ft = { "http", "rest" },
    -- 配置插件选项
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
    -- 这里的 keys 会自动映射到 LazyVim 的快捷键系统中
    keys = {
      {
        "<leader>rr",
        function()
          require("kulala").run()
        end,
        desc = "Send request",
      },
      {
        "<leader>ra",
        function()
          require("kulala").run_all()
        end,
        desc = "Send all requests",
      },
      {
        "<leader>rb",
        function()
          require("kulala").scratchpad()
        end,
        desc = "Open scratchpad",
      },
      {
        "<leader>rn",
        function()
          require("kulala").jump_next()
        end,
        desc = "Next request",
      },
      {
        "<leader>rp",
        function()
          require("kulala").jump_prev()
        end,
        desc = "Prev request",
      },
    },
  },
}
