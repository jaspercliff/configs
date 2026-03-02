local M = {}

function M.setup()
  local dap = require("dap")

  -- 2. Java 调试配置
  dap.configurations.java = {
    {
      type = "java",
      request = "launch",
      name = "Spring Boot (Real-time Log)",
      -- 关键配置：让日志进入 dap-ui 的 console 窗口
      console = "internalConsole",

      -- 核心 JVM 参数
      -- 1. 强制开启彩色日志
      -- 2. 解决中文乱码
      -- 3. 提示 Spring 立即刷新输出流
      vmArgs = "-Dspring.output.ansi.enabled=ALWAYS "
        .. "-Dfile.encoding=UTF-8 "
        .. "-Dspring.main.banner-mode=console",
    },
  }
end
return M
