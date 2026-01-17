return {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown" },
  opts = {
    default = {
      -- *** 核心修改部分 ***
      -- 使用函数来动态获取路径
      dir_path = function()
        -- 1. 获取当前文件所在的目录路径
        local current_file_dir = vim.fn.expand("%:p:h")
        -- 2. 在该路径下追加 'images' 文件夹名
        -- 确保在 Linux/macOS 和 Windows 上都使用正确的路径分隔符
        return current_file_dir .. "/assets"
      end,
      -- *** 核心修改部分结束 ***

      insert_mode = true,
    },
  },
  keys = {
    {
      "<leader>p",
      function()
        require("img-clip").paste_image()
      end,
      mode = "n",
      desc = "Paste image",
    },
  },
}
