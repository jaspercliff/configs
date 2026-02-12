return {
  -- 添加主题插件
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 确保主题插件最先加载
    opts = {
      flavour = "mocha", -- 可选: latte, frappe, macchiato, mocha
    },
  },

  -- 配置 LazyVim 加载该主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
