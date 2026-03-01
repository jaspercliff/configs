return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- 1. UI 基础配置
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1 -- 在状态栏显示查询状态

    -- 2. 【核心】设置保存路径为当前工作目录（项目根目录）下的 .db_queries 文件夹
    -- 使用 getcwd() 确保路径随项目自动切换
    local db_save_path = vim.fn.getcwd() .. "/.db_queries"
    vim.g.db_ui_save_location = db_save_path

    -- 3. 自动创建该目录，防止插件报错
    if vim.fn.isdirectory(db_save_path) == 0 then
      vim.fn.mkdir(db_save_path, "p")
    end

    -- 4. 预定义数据库连接，省去手动 Add 的麻烦
    vim.g.dbs = {
      { name = "hmdp", url = "mariadb://root:passwd@127.0.0.1:3306/hmdp" },
    }
  end,
  config = function()
    -- 将自动命令放在这里，当插件加载时执行
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        -- 设置缓冲区局部快捷键 (注意使用 :DB 而非小写 :db)
        -- <leader>r 执行选中的块或当前行
        vim.keymap.set("v", "<leader>r", ":DB<CR>", { buffer = true, desc = "执行选中 SQL" })
        vim.keymap.set("n", "<leader>r", ":DB<CR>", { buffer = true, desc = "执行当前行 SQL" })

        -- 自动补全集成 (nvim-cmp)
        if pcall(require, "cmp") then
          require("cmp").setup.buffer({
            sources = { { name = "vim-dadbod-completion" } },
          })
        end
      end,
    })
  end,
}
