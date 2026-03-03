-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<A-Left>", "<C-w><")
vim.keymap.set("n", "<A-Right>", "<C-w>>")
vim.keymap.set("n", "<A-Up>", "<C-w>+")
vim.keymap.set("n", "<A-Down>", "<C-w>-")

-- 1. 实时预览：按下 <leader>mw (Markmap Watch)
-- 它会在后台运行并在浏览器打开，实时同步你的修改
vim.keymap.set("n", "<leader>mw", "<cmd>term markmap -w %<cr>", { desc = "Markmap 实时预览" })

-- 2. 一键导出：按下 <leader>me (Markmap Export)
-- 专门为你分享社交媒体准备，将当前文件导出为名为 "share.html" 的文件（隐藏原文件名）
vim.keymap.set("n", "<leader>me", "<cmd>!markmap % -o share.html<cr>", { desc = "导出分享版思维导图" })

vim.keymap.set("n", "<leader>cl", function()
  -- 1. 获取当前 buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- 2. 临时开启修改权限
  vim.bo[bufnr].modifiable = true

  -- 3. 清空内容 (注意：这里使用 sync 方式确保清空完成)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

  -- 4. 关键点：不要立即恢复 readonly！
  -- 因为 Java 的日志是异步持续写入的，必须保持可写状态。
  -- 如果你担心误删代码，可以设置定时器或者只在 Console 类型的 buffer 中保持开启。

  -- 5. (可选) 强制将光标移到最后一行，以便新日志出来时能自动滚动
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_win_set_cursor(0, { line_count, 0 })

  print("Console Cleared & Syncing...")
end, { desc = "Clear Console and Keep Sync" })
