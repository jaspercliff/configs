-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--  clear quickfix list
vim.keymap.set("n", "<leader>cQ", function()
  -- cexpr = 给 quickfix 列表赋值
  -- [] = 空列表
  vim.cmd("cexpr []")
  vim.cmd("cclose")
end, { desc = "Clear and Close Quickfix" })
