-- 在你的插件安装文件里（例如 plugins/dap.lua）
return {
  "mfussenegger/nvim-dap",
  -- 注意：这里用 config，而不是 setup
  config = function()
    local dap = require("dap")

    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Spring Boot (Real-time Log)",
        console = "internalConsole",
        vmArgs = "-Dspring.output.ansi.enabled=ALWAYS "
          .. "-Dfile.encoding=UTF-8 "
          .. "-Dspring.main.banner-mode=console",
      },
    }
  end,
}
