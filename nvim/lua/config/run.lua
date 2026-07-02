local M = {} -- module

-- 解析package 上面的参数为jvm 参数
function M.run_java_jdk21()
  -- 1. 自动保存当前文件
  vim.cmd("silent! write")

  local file_path = vim.fn.expand("%:p") -- 完整绝对路径
  local jvm_args_list = {}

  -- 2. 逐行读取文件内容，解析 package 上方的 // 注释
  for line in io.lines(file_path) do
    -- 去掉行首和行尾的空格
    local trimmed = line:gsub("^%s*", ""):gsub("%s*$", "")

    -- 核心逻辑：如果碰到了 package、class、interface 或 enum，说明已经出了顶部区域，直接结束循环
    if
      trimmed:find("^package%s+")
      or trimmed:find("public%s+class")
      or trimmed:find("class%s+")
      or trimmed:find("interface%s+")
    then
      break
    end

    -- 匹配以 // 开头的行
    if trimmed:find("^//") then
      -- 提取 // 之后的内容
      local arg = trimmed:match("^//%s*(.*)")
      if arg and arg ~= "" then
        table.insert(jvm_args_list, arg)
      end
    end
  end

  -- 3. 将所有找到的注释行，用空格拼接成一个完整的字符串
  local jvm_args = table.concat(jvm_args_list, " ")
  jvm_args = jvm_args:gsub("^%s*", ""):gsub("%s*$", "")

  -- 4. 构建并执行命令
  -- 针对带有空格的文件路径进行 shell 转义，确保稳健
  local safe_file_path = vim.fn.shellescape(file_path)
  local cmd

  if jvm_args ~= "" then
    cmd = string.format("java %s %s", jvm_args, safe_file_path)
  else
    cmd = string.format("java %s", safe_file_path)
  end

  -- 5. 调用 toggleterm 异步执行
  -- 参数说明: exec(cmd, id, size, dir, direction, go_back, open_stdout)
  -- 15: 固定一个 terminal id
  -- "float": 浮动窗口
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

function M.run_bun()
  -- 1. 自动保存当前文件，防止运行旧代码
  vim.cmd("silent! write")
  require("toggleterm").exec("bun start", 15, nil, nil, "horizontal")
end

function M.run_rust()
  -- 1. 自动保存当前文件
  vim.cmd("silent! write")

  local file = vim.fn.expand("%:p") -- 完整绝对路径
  local output = vim.fn.expand("%:p:r") -- 不带后缀的文件名

  -- 2. 构建命令：编译 -> 执行 -> 删除
  -- 使用 [[ ]] 包装路径是为了防止路径中有空格导致命令失效
  local cmd = string.format("rustc '%s' -o '%s' && '%s' && rm '%s'", file, output, output, output)

  -- 3. 调用 ToggleTerm 在浮窗执行
  require("toggleterm").exec(cmd, 15, nil, nil, "float")
end

return M
