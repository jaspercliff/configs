return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          filetypes = {
            "css",
            "scss",
            "html",
            "javascriptreact",
            "typescriptreact",
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
            },
            scss = {
              validate = true,
            },
            less = {
              validate = true,
            },
          },
        },
      },
    },
  },
}
