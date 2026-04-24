-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- run java jdk 11 +
vim.keymap.set("n", "<leader>rj", function()
  require("config.run").run_java_jdk21()
end, { desc = "Java 21 Single File Run" })

vim.keymap.set("n", "<leader>rl", function()
  require("config.run").run_lua()
end, { desc = "run lua file" })
-- =============================================dap
vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F6>", function()
  require("dap").terminate()
end)
vim.keymap.set("n", "<leader>5", "<cmd>DapViewToggle<CR>")

vim.keymap.set("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end)

vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)

vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)

vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)

-- =======================================jdtls
vim.keymap.set("n", "<leader>jb", "<cmd>JdtBytecode<CR>", { desc = "Java: Show bytecode simple" })

vim.keymap.set("n", "<leader>jv", function()
  require("config.run").javap_verbose()
end, { desc = "Java: Show javap verbose" })

-- ====================================== aerial 查看代码结构 structure
vim.keymap.set("n", "<leader>7", "<cmd>AerialToggle! left<CR>")
