return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      -- 注册 leader m 分组
      { "<leader>m", group = "Markdown", icon = { icon = " ", color = "orange" } },

      -- 为具体按键手动指定图标
      { "<leader>mp", icon = { icon = "󰥟 ", color = "green" } }, -- Preview
      { "<leader>mc", icon = { icon = "󰅖 ", color = "red" } }, -- Close/Stop
      { "<leader>mi", icon = { icon = "󰥶 ", color = "cyan" } }, -- Image paste
    },
  },
}
