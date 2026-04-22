-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("config.snippets")

vim.o.guifont = "Menlo:h17"
vim.opt.linespace = 5

vim.o.exrc = true
vim.o.secure = true

vim.o.background = "dark"
