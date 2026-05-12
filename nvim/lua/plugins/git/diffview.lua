---@diagnostic disable: unicode-name
-- 上方的注释用于禁用 Lua 诊断对中文字符和图标的报错

return {
  "sindrets/diffview.nvim",
  -- 插件依赖项
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- 触发加载的命令
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" },
  -- 绑定到 LazyVim 的快捷键
  keys = {
    -- 1. 查看当前改动 (直接回车)
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },

    -- 2. 手动输入分支名 (注意最后那个空格，且没有 <cr>)
    { "<leader>gv", ":DiffviewOpen ", desc = "Diffview: 输入分支名" },

    -- 3. 查看当前文件历史
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (Current File)" },

    -- 4. 查看整个项目提交历史
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (Project)" },

    -- 5. 快速退出 Diffview
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
  },
  opts = function()
    local actions = require("diffview.actions")

    return {
      diff_binaries = false, -- 是否显示二进制文件(img ...)的差异
      enhanced_diff_hl = true, -- 是否启用增强型高亮
      git_cmd = { "git" }, -- Git 执行命令
      hg_cmd = { "hg" }, -- Hg 执行命令
      use_icons = true, -- 使用图标 (需要 nvim-web-devicons)
      show_help_hints = true, -- 显示帮助提示
      watch_index = true, -- 自动监听索引变化
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = { diff_merges = "combined" },
            multi_file = { diff_merges = "first-parent" },
          },
          hg = { single_file = {}, multi_file = {} },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {},
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", actions.select_next_entry, { desc = "下个条目" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "上个条目" } },
          { "n", "[F", actions.select_first_entry, { desc = "第一个条目" } },
          { "n", "]F", actions.select_last_entry, { desc = "最后一个条目" } },
          { "n", "gf", actions.goto_file_edit, { desc = "在原标签页编辑" } },
          { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "水平分割打开" } },
          { "n", "<C-w>gf", actions.goto_file_tab, { desc = "新标签页打开" } },
          { "n", "<leader>e", actions.focus_files, { desc = "聚焦文件面板" } },
          { "n", "<leader>b", actions.toggle_files, { desc = "显示/隐藏文件面板" } },
          { "n", "g<C-x>", actions.cycle_layout, { desc = "切换布局" } },
          { "n", "[x", actions.prev_conflict, { desc = "跳转上个冲突" } },
          { "n", "]x", actions.next_conflict, { desc = "跳转下个冲突" } },
          { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "冲突：选择 OURS" } },
          { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "冲突：选择 THEIRS" } },
          { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "冲突：选择 BASE" } },
          { "n", "<leader>ca", actions.conflict_choose("all"), { desc = "冲突：选择全部" } },
          { "n", "dx", actions.conflict_choose("none"), { desc = "冲突：删除冲突块" } },
          { "n", "<leader>cO", actions.conflict_choose_all("ours"), { desc = "全文件：选择 OURS" } },
          { "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "全文件：选择 THEIRS" } },
          { "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "全文件：选择 BASE" } },
          { "n", "<leader>cA", actions.conflict_choose_all("all"), { desc = "全文件：选择全部" } },
          { "n", "dX", actions.conflict_choose_all("none"), { desc = "全文件：删除冲突块" } },
        },
        diff1 = {
          { "n", "g?", actions.help({ "view", "diff1" }), { desc = "帮助" } },
        },
        diff2 = {
          { "n", "g?", actions.help({ "view", "diff2" }), { desc = "帮助" } },
        },
        diff3 = {
          { { "n", "x" }, "2do", actions.diffget("ours"), { desc = "获取 OURS 版本" } },
          { { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "获取 THEIRS 版本" } },
          { "n", "g?", actions.help({ "view", "diff3" }), { desc = "帮助" } },
        },
        diff4 = {
          { { "n", "x" }, "1do", actions.diffget("base"), { desc = "获取 BASE 版本" } },
          { { "n", "x" }, "2do", actions.diffget("ours"), { desc = "获取 OURS 版本" } },
          { { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "获取 THEIRS 版本" } },
          { "n", "g?", actions.help({ "view", "diff4" }), { desc = "帮助" } },
        },
        file_panel = {
          { "n", "j", actions.next_entry, { desc = "光标移至下个条目" } },
          { "n", "<down>", actions.next_entry, { desc = "光标移至下个条目" } },
          { "n", "k", actions.prev_entry, { desc = "光标移至上个条目" } },
          { "n", "<up>", actions.prev_entry, { desc = "光标移至上个条目" } },
          { "n", "<cr>", actions.select_entry, { desc = "打开差异" } },
          { "n", "o", actions.select_entry, { desc = "打开差异" } },
          { "n", "l", actions.select_entry, { desc = "打开差异" } },
          { "n", "<2-LeftMouse>", actions.select_entry, { desc = "打开差异" } },
          { "n", "-", actions.toggle_stage_entry, { desc = "暂存/取消暂存" } },
          { "n", "s", actions.toggle_stage_entry, { desc = "暂存/取消暂存" } },
          { "n", "S", actions.stage_all, { desc = "暂存所有" } },
          { "n", "U", actions.unstage_all, { desc = "取消暂存所有" } },
          { "n", "X", actions.restore_entry, { desc = "还原条目" } },
          { "n", "L", actions.open_commit_log, { desc = "打开提交日志" } },
          { "n", "zo", actions.open_fold, { desc = "展开折叠" } },
          { "n", "h", actions.close_fold, { desc = "关闭折叠" } },
          { "n", "zc", actions.close_fold, { desc = "关闭折叠" } },
          { "n", "za", actions.toggle_fold, { desc = "切换折叠" } },
          { "n", "zR", actions.open_all_folds, { desc = "展开所有折叠" } },
          { "n", "zM", actions.close_all_folds, { desc = "关闭所有折叠" } },
          { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "向上滚动" } },
          { "n", "<c-f>", actions.scroll_view(0.25), { desc = "向下滚动" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "下个条目" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "上个条目" } },
          { "n", "[F", actions.select_first_entry, { desc = "第一个条目" } },
          { "n", "]F", actions.select_last_entry, { desc = "最后一个条目" } },
          { "n", "gf", actions.goto_file_edit, { desc = "原标签页打开" } },
          { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "水平分割打开" } },
          { "n", "<C-w>gf", actions.goto_file_tab, { desc = "新标签页打开" } },
          { "n", "i", actions.listing_style, { desc = "切换列表/树形" } },
          { "n", "f", actions.toggle_flatten_dirs, { desc = "切换扁平目录" } },
          { "n", "R", actions.refresh_files, { desc = "刷新" } },
          { "n", "<leader>e", actions.focus_files, { desc = "聚焦文件面板" } },
          { "n", "<leader>b", actions.toggle_files, { desc = "隐藏/显示面板" } },
          { "n", "g<C-x>", actions.cycle_layout, { desc = "切换布局" } },
          { "n", "[x", actions.prev_conflict, { desc = "上个冲突" } },
          { "n", "]x", actions.next_conflict, { desc = "下个冲突" } },
          { "n", "g?", actions.help("file_panel"), { desc = "帮助" } },
          { "n", "<leader>cO", actions.conflict_choose_all("ours"), { desc = "全选 OURS" } },
          { "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "全选 THEIRS" } },
          { "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "全选 BASE" } },
          { "n", "<leader>cA", actions.conflict_choose_all("all"), { desc = "全选全部" } },
          { "n", "dX", actions.conflict_choose_all("none"), { desc = "全删冲突块" } },
        },
        file_history_panel = {
          { "n", "g!", actions.options, { desc = "选项面板" } },
          { "n", "<C-A-d>", actions.open_in_diffview, { desc = "在 Diffview 中打开" } },
          { "n", "y", actions.copy_hash, { desc = "复制提交哈希" } },
          { "n", "L", actions.open_commit_log, { desc = "详细提交记录" } },
          { "n", "X", actions.restore_entry, { desc = "还原到此状态" } },
          { "n", "zo", actions.open_fold, { desc = "展开折叠" } },
          { "n", "zc", actions.close_fold, { desc = "关闭折叠" } },
          { "n", "h", actions.close_fold, { desc = "关闭折叠" } },
          { "n", "za", actions.toggle_fold, { desc = "切换折叠" } },
          { "n", "zR", actions.open_all_folds, { desc = "展开所有" } },
          { "n", "zM", actions.close_all_folds, { desc = "关闭所有" } },
          { "n", "j", actions.next_entry, { desc = "移至下个条目" } },
          { "n", "<down>", actions.next_entry, { desc = "移至下个条目" } },
          { "n", "k", actions.prev_entry, { desc = "移至上个条目" } },
          { "n", "<up>", actions.prev_entry, { desc = "移至上个条目" } },
          { "n", "<cr>", actions.select_entry, { desc = "查看差异" } },
          { "n", "o", actions.select_entry, { desc = "查看差异" } },
          { "n", "l", actions.select_entry, { desc = "查看差异" } },
          { "n", "<2-LeftMouse>", actions.select_entry, { desc = "查看差异" } },
          { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "向上滚动" } },
          { "n", "<c-f>", actions.scroll_view(0.25), { desc = "向下滚动" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "下个条目" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "上个条目" } },
          { "n", "[F", actions.select_first_entry, { desc = "第一个条目" } },
          { "n", "]F", actions.select_last_entry, { desc = "最后一个条目" } },
          { "n", "gf", actions.goto_file_edit, { desc = "原标签页打开" } },
          { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "水平分割打开" } },
          { "n", "<C-w>gf", actions.goto_file_tab, { desc = "新标签页打开" } },
          { "n", "<leader>e", actions.focus_files, { desc = "聚焦面板" } },
          { "n", "<leader>b", actions.toggle_files, { desc = "切换面板" } },
          { "n", "g<C-x>", actions.cycle_layout, { desc = "切换布局" } },
          { "n", "g?", actions.help("file_history_panel"), { desc = "帮助" } },
        },
        option_panel = {
          { "n", "<tab>", actions.select_entry, { desc = "更改当前选项" } },
          { "n", "q", actions.close, { desc = "关闭面板" } },
          { "n", "g?", actions.help("option_panel"), { desc = "帮助" } },
        },
        help_panel = {
          { "n", "q", actions.close, { desc = "关闭" } },
          { "n", "<esc>", actions.close, { desc = "关闭" } },
        },
      },
    }
  end,
}
