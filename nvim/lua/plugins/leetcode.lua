return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  opts = {
    cn = {
      enabled = true, -- leetcode.cn
    },
    lang = "java",

    -- 1. 让插件生成原生文件时，先去一个临时干净的地方（避免污染你的主力仓库根目录）
    storage = {
      home = vim.fn.expand("~/.local/share/leetcode_files"),
      cache = vim.fn.expand("$HOME/.cache/leetcode"),
    },
    hooks = {
      question_enter = function(q)
        -- 1. 确保能拿到当前题目 Buffer 的编号
        local bufnr = q.bufnr or vim.api.nvim_get_current_buf()

        -- 2. 强行向 Neovim 获取这个 Buffer 对应的绝对路径字符串，彻底避开 Table 类型的坑！
        local current_file_path = vim.api.nvim_buf_get_name(bufnr)
        if not current_file_path or current_file_path == "" then
          return
        end

        -- 3. 获取文件名和后缀
        local file_name = vim.fs.basename(current_file_path) -- 例如 "3043.longest-common-prefix.java"
        local ext = vim.fn.fnamemodify(file_name, ":e") -- 例如 "java"
        local lang = ext == "py" and "python" or ext

        -- 4. 从文件名中精准解析出【题号】和【英文名slug】
        local clean_id, slug = string.match(file_name, "^(%d+)%.([^%.]+)%.")

        -- 5. 如果连文件名都解析不出数字（作为特殊题目兜底）
        local id = tonumber(clean_id)
        local folder_name
        if not id then
          folder_name = "special-problems"
          slug = slug or "unknown"
        else
          -- 计算百位数区间 (3043 -> 3001-3100)
          local range_start = math.floor((id - 1) / 100) * 100 + 1
          local range_end = range_start + 99
          folder_name = string.format("%04d-%04d", range_start, range_end)
        end

        -- 6. 拼接目标存放路径
        local prob_name = string.format("%04d-%s", id or 0, slug)
        local target_base = vim.fn.expand("~/code/learnDS/leetcode")
        local target_dir = vim.fs.joinpath(target_base, lang, folder_name, prob_name)

        -- 7. 创建深层文件夹
        if vim.fn.isdirectory(target_dir) == 0 then
          vim.fn.mkdir(target_dir, "p")
        end

        local target_file_path = vim.fs.joinpath(target_dir, file_name)

        -- 8. 物理迁移：将临时目录的代码文件拷贝过去
        if vim.fn.filereadable(target_file_path) == 0 then
          vim.cmd("silent! write") -- 先保存当前 buffer 里的模板代码
          vim.fn.writefile(vim.fn.readfile(current_file_path, "b"), target_file_path, "b")
        end

        -- 9. 无缝把当前 Neovim 的 Buffer 切换到新克隆的深层路径文件上
        vim.api.nvim_buf_set_name(bufnr, target_file_path)
        vim.cmd("silent! edit!")
      end,
    },
  },
}
