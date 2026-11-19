local CSS_NAV = require("config.css-nav")

local DEFINITION_KEY = "gd"
local REFERENCES_KEY = "gr"
local DEFINITION_DESC = "Goto Definition"
local REFERENCES_DESC = "References"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              DEFINITION_KEY,
              CSS_NAV.definition_keymap,
              desc = DEFINITION_DESC,
              has = "definition",
            },
            {
              REFERENCES_KEY,
              CSS_NAV.references_keymap,
              desc = REFERENCES_DESC,
              nowait = true,
            },
          },
        },
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
        -- logback 等配置的语法无法用 XSD 描述（logback 官方说明），
        -- Lemminx 对无 grammar 的 XML 默认报 hint，这里直接忽略该诊断。
        lemminx = {
          settings = {
            xml = {
              validation = {
                noGrammar = "ignore",
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>rh",
        function()
          vim.fn.jobstart({
            "open",
            vim.fn.expand("%:p"),
          }, { detach = true })
        end,
        desc = "Open HTML in Browser",
      },
    },
  },
}
