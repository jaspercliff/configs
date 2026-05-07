local M = {} -- module

function M.run_java_jdk21()
  -- 1. 自动保存当前文件，防止运行旧代码
  vim.cmd("silent! write")
  -- 2. 获取当前文件的绝对路径
  local file = vim.fn.expand("%:p")
  -- 3. 构建命令 (JDK 11+ 支持直接 java 运行 .java 文件)
  local cmd = string.format("java %s", file)
  -- 4. 在浮动窗口执行
  -- 参数说明: exec(命令, 终端ID, 窗口大小, 方向)
  require("toggleterm").exec(cmd, 15, nil, nil, "float")
end

function M.run_lua()
  -- 1. 自动保存当前文件，防止运行旧代码
  vim.cmd("silent! write")
  -- 2. 获取当前文件的绝对路径
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h") --  文件所在目录
  local cmd = string.format("cd %s && lua %s", dir, file)
  require("toggleterm").exec(cmd, 15, nil, nil, "float")
end

function M.javap_verbose()
  -- 1. 获取当前文件的完整路径（不含后缀）
  -- 注意：javap 运行在编译后的 .class 上，这里假设你的类在 target 或 bin 目录下
  -- 或者直接在当前目录有编译好的文件
  local file_path = vim.fn.expand("%:p:r")

  -- 2. 构造命令 ( -v: verbose, -p: 显示所有类和成员 )
  local cmd = string.format("javap -v -p %s", file_path)

  -- 3. 调用 ToggleTerm
  local Terminal = require("toggleterm.terminal").Terminal
  local javap_term = Terminal:new({
    cmd = cmd,
    direction = "float", -- 浮窗模式，也可以换成 'horizontal' 或 'vertical'
    close_on_exit = false, -- 运行完不直接关闭，方便查看
    hidden = true,
    on_open = function(term)
      -- 在终端窗口内按 q 直接退出
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })

  javap_term:toggle()
end

return M
