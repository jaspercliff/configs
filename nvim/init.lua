-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("config.snippets")

vim.o.guifont = "JetBrains Mono:h12"
vim.opt.linespace = 3

vim.o.exrc = true
vim.o.secure = true

vim.o.background = "dark"
