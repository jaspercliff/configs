return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>z",
      function()
        require("yazi").yazi()
      end,
      desc = "Open yazi at current file",
    },
  },
  opts = {
    -- 浮窗配置
    open_for_directories = true, -- 如果打开的是目录，自动唤起 yazi
    keymaps = {
      show_help = "<f1>", -- 在 yazi 浮窗内看帮助
    },
  },
}
