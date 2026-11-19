-- 关闭 jdtls 在 LspAttach 时对 main class 的全量扫描。
-- 该扫描会调用 java-debug 的 vscode.java.resolveClasspath，解析 included build /
-- 非项目文件时刷：
--   "Referenced classpath provider does not exist: org.eclipse.buildship.core.classpathprovider"
-- 关闭后，调试 main 方法仍走 nvim-dap / <leader>dc 按需解析，不影响调试。
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.dap_main = false
      return opts
    end,
  },
}
