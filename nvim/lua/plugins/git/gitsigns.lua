return {
  {
    "lewis6991/gitsigns.nvim",

    -- LazyVim 会自动 lazy-load，这里保留默认即可
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      -- ========== 符号样式 ==========
      signs = {
        add = { text = "┃" }, -- 新增行
        change = { text = "┃" }, -- 修改行
        delete = { text = "_" }, -- 删除行
        topdelete = { text = "‾" }, -- 文件顶部删除
        changedelete = { text = "~" }, -- 修改+删除
        untracked = { text = "┆" }, -- 未追踪文件
      },

      -- 已 stage 状态的符号
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },

      signs_staged_enable = true,

      -- ========== 显示控制 ==========
      signcolumn = true, -- 是否显示 sign 列
      numhl = false, -- 行号高亮
      linehl = false, -- 整行高亮
      word_diff = false, -- 单词级 diff

      watch_gitdir = {
        follow_files = true,
      },

      auto_attach = true,
      attach_to_untracked = false,

      -- ========== 当前行 blame ==========
      current_line_blame = false, -- 默认关闭
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- eol | overlay | right_align
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },

      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",

      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,

      preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      -- ========== 关键：LazyVim 推荐的 on_attach 写法 ==========
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        -- ========================
        -- 跳转 hunk
        -- ========================
        -- 跳到下一个 hunk（改动块）
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Next Hunk")
        -- 跳到上一个 hunk
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Prev Hunk")

        -- ========================
        -- Hunk 操作
        -- ========================
        -- stage current hunk
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
        --  restore  head 撤销current hunk
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")

        -- 视觉模式选中 hunk
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Selected Hunk")

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Selected Hunk")

        -- 整个 buffer 该操作不能 u  nstage buffer 可以使用lazygit unstage buffer
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Buffer")

        -- 预览
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk")
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Inline Preview")

        -- blame
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame Line")

        -- diff 这次修改了什么
        map("n", "<leader>hd", gitsigns.diffthis, "Diff This")
        -- 相比上次commit有什么区别
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, "Diff Against ~")

        -- quickfix
        -- add all hunks to quickfix
        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, "Quickfix All")
        -- add current hunk to quickfix
        map("n", "<leader>hq", gitsigns.setqflist, "Quickfix Current")

        -- ========================
        -- Toggle
        -- ========================
        -- 开关 当前行的 blame 信息
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Blame")
        -- 开关 当前行的 blame 信息 word level
        map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle Word Diff")

        -- ========================
        -- Text Object
        -- ========================
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
      end,
    },
  },
}
