return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  opts = {
    cn = {
      enabled = true, -- leetcode.cn
    },
    lang = "java",
    storage = {
      home = vim.fn.expand("~/code/datastructure/leetcode/src/main/java/"),
    },
  },
}
