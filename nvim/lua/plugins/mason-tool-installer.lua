return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "lemminx", -- xml lsp
      "google-java-format",
      "java-debug-adapter", --java dap
      "java-test",
    },
  },
}
