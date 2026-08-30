return {
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    version = "1.*",

    opts = {
      winbar = {
        base_sections = {
          breakpoints = { label = "Breakpoints", keymap = "b" },
          scopes = { label = "Scopes", keymap = "s" },
          exceptions = { label = "Exceptions", keymap = "e" },
          watches = { label = "Watches", keymap = "w" },
          threads = { label = "Threads", keymap = "t" },
          repl = { label = "REPL", keymap = "r" },
          sessions = { label = "Sessions", keymap = "k" },
          console = { label = "Console", keymap = "c" },
        },

        sections = {
          "watches",
          "scopes",
          "exceptions",
          "breakpoints",
          "threads",
          "repl",
          "console",
        },

        default_section = "scopes",
      },

      icons = {
        collapsed = "󰅂 ",
        disabled = "",
        disconnect = "",
        enabled = "",
        expanded = "󰅀 ",
        filter = "󰈲",
        negate = " ",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
      },
    },

    config = function(_, opts)
      require("dap-view").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-view-term",
        callback = function(event)
          vim.keymap.set("n", "<leader>dc", function()
            vim.bo[event.buf].modifiable = true

            vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, {})

            vim.bo[event.buf].modifiable = false
          end, {
            buffer = event.buf,
            desc = "Clear DAP Console",
          })
        end,
      })
    end,
  },
}
