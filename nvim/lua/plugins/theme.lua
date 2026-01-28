return {
  -- 1. 确保安装 Catppuccin 插件
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  -- priority = 1000: 确保它在大多数插件之前加载

  -- 2. 覆盖 LazyVim 的核心配置
  {
    "LazyVim/LazyVim",
    opts = {
      -- 在 LazyVim 核心配置中指定 colorscheme
      colorscheme = "catppuccin",
    },
  },
  -- 核心配置：清除背景颜色 让nvim的背景是终端的配置 而不是自己的
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none" })
    end,
  },
}
