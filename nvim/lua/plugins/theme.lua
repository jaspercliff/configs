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
}
