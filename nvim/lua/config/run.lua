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

return M
