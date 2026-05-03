return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- 先保留你原来的 dashboard 配置
    opts.dashboard = opts.dashboard or {}
    opts.dashboard.sections = {
      {
        section = "terminal",
        cmd = "echo \"Hello! Today is $(date '+%A, %B %d')\nTime: $(date '+%H:%M')\" | cowsay -r",
        height = 12,
        padding = 1,
        indent = 2,
        ttl = 0,
      },
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    }

    -- explorer 里的 java-helper 快捷键
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.explorer = opts.picker.sources.explorer or {}

    local patch = require("java-helper.integrations.snacks_explorer").patch({
      -- 可选：java-helper 的配置
      author = "jasper",
      since_format = "%Y-%m-%d %H:%M:%S",
    }, {
      key = "J", -- explorer 列表里按 N 创建
      init_key = "M",
    })

    opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer, patch)
  end,
  keys = {
    {
      "<leader>gD",
      function()
        -- 尝试对比上游分支 (upstream)，如果没有上游则对比 main
        Snacks.picker.git_diff({
          base = "@{u}", -- @{u} 代表当前分支跟踪的远程分支，比写死 "origin" 更智能
          group = true,
        })
      end,
      desc = "Git Diff (Upstream)",
    },
  },
}
