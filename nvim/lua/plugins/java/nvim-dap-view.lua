return {
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    version = "1.*",
    opts = {
      winbar = {
        base_sections = {
          -- Labels can be set dynamically with functions
          -- Each function receives the window's width and the current section as arguments
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
        -- 设置默认选中的板块
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
  },
}
