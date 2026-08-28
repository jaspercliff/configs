-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- run java jdk 11 +
vim.keymap.set("n", "<leader>rj", function()
  require("config.run").run_java_jdk21()
end, { desc = "Java 21 Single File Run" })

vim.keymap.set("n", "<leader>rl", function()
  require("config.run").run_lua()
end, { desc = "run lua file" })

vim.keymap.set("n", "<leader>rr", function()
  require("config.run").run_rust()
end, { desc = "run rust file" })
-- =============================================
-- DAP
-- =============================================

local dap = require("dap")

-- Continue / 启动 Debug
vim.keymap.set("n", "<leader>dc", function()
  if vim.bo.filetype == "java" then
    require("jdtls.dap").setup_dap_main_class_configs({
      on_ready = function()
        -- 获取当前文件名（类名）
        local current_class = vim.fn.expand("%:t:r")
        local configs = dap.configurations.java or {}

        -- 查找当前类对应的 mainClass
        local target_index = nil

        for i, config in ipairs(configs) do
          if config.mainClass and config.mainClass:match("%." .. current_class .. "$") then
            target_index = i
            break
          end
        end

        -- 如果找到当前类，把它移动到第一位
        if target_index and target_index > 1 then
          local target_config = table.remove(configs, target_index)
          table.insert(configs, 1, target_config)
        end

        -- 启动 Debug
        dap.continue()
      end,
    })
  else
    -- 非 Java 文件
    dap.continue()
  end
end, { desc = "DAP Continue" })

-- Terminate
vim.keymap.set("n", "<leader>dt", function()
  dap.terminate()
end, { desc = "DAP Terminate" })

-- DAP View
vim.keymap.set("n", "<leader>dv", "<cmd>DapViewToggle<CR>", {
  desc = "DAP View Toggle",
})

-- Toggle Breakpoint
vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

-- Step Over
vim.keymap.set("n", "<leader>do", function()
  dap.step_over()
end, { desc = "DAP Step Over" })

-- Step Into
vim.keymap.set("n", "<leader>di", function()
  dap.step_into()
end, { desc = "DAP Step Into" })

-- Step Out
vim.keymap.set("n", "<leader>dx", function()
  dap.step_out()
end, { desc = "DAP Step Out" })

-- =======================================jdtls
vim.keymap.set("n", "<leader>jb", "<cmd>JdtBytecode<CR>", { desc = "Java: Show bytecode simple" })

vim.keymap.set("n", "<leader>jv", function()
  require("config.run").javap_verbose()
end, { desc = "Java: Show javap verbose" })

-- ====================================== aerial 查看代码结构 structure
vim.keymap.set("n", "<leader>7", "<cmd>AerialToggle! left<CR>")

-- ====================================== bun
vim.keymap.set("n", "<leader>rb", function()
  require("config.run").run_bun()
end, { desc = "run docusaurus" })

vim.keymap.set("i", "jk", "<Esc>")
