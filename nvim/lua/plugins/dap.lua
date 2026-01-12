return {
  -- 匹配 nvim-dap 插件的名称
  "mfussenegger/nvim-dap",

  -- 配置函数：这里的逻辑将在 nvim-dap 插件加载后执行
  config = function()
    local dap = require("dap")
    -- [[ 1. 动态查找 VENV Python 路径的函数 ]]
    local function get_venv_python_path()
      local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")

      if venv_path ~= "" then
        -- 检查 Linux/macOS 路径: .venv/bin/python
        local linux_path = venv_path .. "/bin/python"
        if vim.fn.filereadable(linux_path) == 1 then
          return linux_path
        end

        -- 检查 Windows 路径: .venv/Scripts/python
        local win_path = venv_path .. "/Scripts/python"
        if vim.fn.filereadable(win_path) == 1 then
          return win_path
        end
      end
      -- 如果找不到，回退到系统默认的 python
      return "python"
    end

    -- [[ 2. 配置 Python Debug Adapter (debugpy) ]]
    dap.adapters.python = {
      type = "executable",
      -- 使用 VENV 解释器来运行 debugpy.adapter
      command = get_venv_python_path(),
      args = { "-m", "debugpy.adapter" },
    }

    -- [[ 3. 配置 Python Launch/Attach 启动项 ]]
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch Current File (VENV)",
        program = "${file}",
        pythonPath = get_venv_python_path(),
        cwd = "${workspaceFolder}",
        env = {
          PYTHONPATH = "${workspaceFolder}",
        },
        justMyCode = true,
      },
    }

    -- ----------------------------------------------------
    -- 额外的快捷键配置
    -- -- ----------------------------------------------------
    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
    end, { desc = "DAP: Continue/Start" })
    vim.keymap.set("n", "<leader>b", function()
      require("dap").toggle_breakpoint()
    end, { desc = "DAP: Toggle Breakpoint" })
  end,
}
