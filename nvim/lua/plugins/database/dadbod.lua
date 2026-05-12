return {
  {
    "tpope/vim-dadbod",
    lazy = false, --  关键：必须提前加载，避免重复注册
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },

    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },

    init = function()
      vim.g.db_ui_use_nerd_fonts = 1

      vim.g.dbs = {
        archLearn = "mysql://@arch:3307/learn",
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.keymap.set("v", "<A-CR>", "db#op_exec()", { expr = true, buffer = true, desc = "Execute selection" })
          vim.keymap.set("n", "<A-CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute query" })
        end,
      })
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    lazy = true,
  },
}
