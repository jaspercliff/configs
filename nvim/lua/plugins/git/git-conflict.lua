return {
  "akinsho/git-conflict.nvim",
  version = "*",
  config = true,
  opts = {
    default_mappings = false, -- 自己定义了 keys，关掉默认映射
  },
  keys = {
    { "<leader>gco", "<Plug>(git-conflict-ours)", desc = "Choose Ours" },
    { "<leader>gct", "<Plug>(git-conflict-theirs)", desc = "Choose Theirs" },
    { "<leader>gcb", "<Plug>(git-conflict-both)", desc = "Choose Both" },
    { "<leader>gcn", "<Plug>(git-conflict-none)", desc = "Choose none" },
    { "<leader>gcq", "<cmd>GitConflictListQf<cr>", desc = "List All Conflicts" },
  },
}
