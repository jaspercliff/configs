return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- 主题插件不能懒加载，必须在启动时加载
    priority = 1000, -- 确保主题在其他插件之前加载
    config = function()
      require("github-theme").setup({
        -- 这里可以根据你的喜好调整
        options = {
          transparent = false, -- 是否背景透明
          styles = {
            comments = "italic", -- 注释使用斜体
          },
        },
      })

      -- 立即应用 github_dark
      vim.cmd("colorscheme github_dark")
    end,
  },
}
