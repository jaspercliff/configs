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
