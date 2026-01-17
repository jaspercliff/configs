-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- unnamed: 指的是 Neovim 的无名寄存器（Unnamed Register）。当你执行 y (yank)、d (delete) 或 c (change) 时，内容默认存放在这里。
-- plus: 指的是系统剪贴板寄存器（在 Vim 中表示为 + 寄存器）。这对应于你在其他软件里用 Ctrl+C 和 Ctrl+V 操作的那个剪贴板。
-- unnamedplus: 将两者关联。
vim.opt.clipboard = "unnamedplus"
