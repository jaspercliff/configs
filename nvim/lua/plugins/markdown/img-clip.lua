-- 在你的 plugins/img-clip.lua 或对应文件里
return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- 核心：让路径相对于当前编辑的文件（.md 所在目录）
      relative_to_current_file = true,

      -- 目录名：会在 .md 文件旁边创建 assets/
      dir_path = "assets", -- 可以改成 "images"、"img"、"pics" 等

      -- 不用绝对路径（保持相对，便于 git / 迁移）
      use_absolute_path = false,

      -- 其他常用设置
      prompt_for_name = false, -- false = 自动文件名（时间戳等）
      file_name = "%Y%m%d%H%M%S", -- 或 "%f-clip"（带当前文件名）
      extension = "png", -- 强制默认后缀为 png
      template = "![$CURSOR]($FILE_PATH)", -- Markdown 插入模板

      -- 自动创建目录（超级有用）
      create_dir = true,
    },

    -- 如果你只在 markdown 用，可以在这里覆盖
    filetypes = {
      markdown = {
        template = "![$CURSOR]($FILE_PATH)",
      },
    },
  },
  keys = {
    { "<leader>mi", "<cmd>PasteImage<cr>", desc = "Paste Image from Clipboard" },
  },
}
