return {
  "neovim/nvim-lspconfig",
  opts = {
    -- make sure mason installs the server
    servers = {
      jdtls = {},
    },
    setup = {
      jdtls = function()
        return true -- avoid duplicate servers
        -- 启用 Java LSP（jdtls），但禁止 lspconfig 自动启动，避免重复 LSP 冲突，让 LazyVim 用专用方式管理 Java
      end,
    },
  },
}
