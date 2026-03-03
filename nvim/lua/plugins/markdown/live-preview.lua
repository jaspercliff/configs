return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>mp", "<cmd>LivePreview start<cr>", desc = "开启 Markdown 实时预览" },
    { "<leader>mc", "<cmd>LivePreview close<cr>", desc = "关闭 Markdown 实时预览" },
  },
  opts = {
    port = 5678,
  },
}
