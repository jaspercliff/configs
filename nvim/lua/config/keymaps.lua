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
-- =============================================dap
-- vim.keymap.set("n", "<F5>", function()
--   require("dap").continue()
-- end)
vim.keymap.set("n", "<F5>", function()
  if vim.bo.filetype == "java" then
    local dap = require("dap")

    require("jdtls.dap").setup_dap_main_class_configs({
      on_ready = function()
        -- 获取当前文件名（即类名）
        local current_class = vim.fn.expand("%:t:r")
        local configs = dap.configurations.java or {}

        -- 寻找匹配当前类名的配置索引
        local target_index = nil
        for i, config in ipairs(configs) do
          if config.mainClass and config.mainClass:match("%." .. current_class .. "$") then
            target_index = i
            break
          end
        end

        -- 如果找到了，把它移到列表的第一位 (index 1)
        if target_index and target_index > 1 then
          local target_config = table.remove(configs, target_index)
          table.insert(configs, 1, target_config)
        end

        -- 唤起弹窗，此时第一项就是当前类，直接按回车即可
        dap.continue()
      end,
    })
  else
    -- 非 Java 文件，正常走默认逻辑
    require("dap").continue()
  end
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

-- ====================================== bun
vim.keymap.set("n", "<leader>rb", function()
  require("config.run").run_bun()
end, { desc = "run docusaurus" })

vim.keymap.set("i", "jk", "<Esc>")
