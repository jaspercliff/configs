-- LSP 跳转时序修复需在 LSP handler 注册前生效
require("config.jdt-lsp-fix")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("config.snippets")

vim.o.guifont = "JetBrains Mono:h12"
vim.opt.linespace = 3

vim.o.exrc = true
vim.o.secure = true

vim.o.background = "dark"
