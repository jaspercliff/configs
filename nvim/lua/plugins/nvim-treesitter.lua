return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "css",
        "scss",
        "less",
        "html",
        "javascript",
        "typescript",
        "tsx",
        "json",
      },
    },
  },
}
