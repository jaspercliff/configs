return
-- 1. Git 状态标记与快速操作 (Gitsigns)
{
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- 懒加载：只在打开文件时加载
  opts = {
    -- 基础样式设置
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    current_line_blame = false, -- 默认关闭，你可以通过 <leader>tb 开启

    -- 这里就是你提供的核心配置逻辑
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- --- 导航 (Navigation) ---
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "Next Git Hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "Prev Git Hunk" })

      -- --- 核心动作 (Actions) ---
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })

      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Selected" })

      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Selected" })

      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Inline" })

      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Full Blame" })

      -- --- 对比与快速修复 ---
      map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, { desc = "Diff against Last Commit" })

      map("n", "<leader>hQ", function()
        gitsigns.setqflist("all")
      end, { desc = "All Hunks to Quickfix" })
      map("n", "<leader>hq", gitsigns.setqflist, { desc = "Buffer Hunks to Quickfix" })

      -- --- 开关 (Toggles) ---
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Blame Line" })
      map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

      -- --- 文本对象 (Text object) ---
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Git Hunk" })
    end,
  },
}
