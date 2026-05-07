return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>ze",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- 在当前工作目录打开 yazi
      "<leader>zw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open yazi in the current working directory",
    },
  },
  opts = {
    -- 浮窗配置
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
