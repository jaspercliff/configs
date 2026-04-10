return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            -- 每次打开都会显示：2024-03-21 14:30:05
            cmd = "echo \"Hello! Today is $(date '+%A, %B %d')\nTime: $(date '+%H:%M')\" | cowsay -r",
            height = 12,
            padding = 1,
            indent = 2,
            -- 关键配置：将缓存时间设为 0，强制每次打开都重新运行命令
            ttl = 0,
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
