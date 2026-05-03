return {
  "akinsho/git-conflict.nvim",
  version = "*",
  -- 关键：只要读写文件就加载，确保冲突高亮能第一时间显示
  event = "BufReadPost",
  opts = {
    default_mappings = false,
  },
  keys = {
    -- 建议改用 <cmd> 形式，比 <Plug> 在懒加载环境下更稳定
    { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
    { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
    { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
    { "<leader>gcn", "<cmd>GitConflictChooseNone<cr>", desc = "Choose None" },
    { "<leader>gcq", "<cmd>GitConflictListQf<cr>", desc = "List All Conflicts" },
    -- 顺手把跳转也加上，方便像 IDEA 一样快速定位
    { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Conflict" },
    { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
  },
}
