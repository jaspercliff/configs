return {
  {
    "Jezda1337/nvim-html-css",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable_on = {
        "html",
        "jsx",
        "tsx",
      },

      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "rounded",
          position = "cursor",
        },
      },

      documentation = {
        auto_show = true,
      },

      peek = {
        enabled = true,
        border = "rounded",
        position = "cursor",
        width = 0.5,
        height = 0.5,
        focus = true,
        style = "minimal",
      },

      style_sheets = {
        -- 改成项目中 chess.css 相对于项目根目录的路径
        "./src/css/chess.css",
      },
    },
  },
}
