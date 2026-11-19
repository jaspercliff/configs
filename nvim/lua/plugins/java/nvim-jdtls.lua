return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- 关闭 LspAttach 时全量扫描 main class。
      -- java-debug 解析 included build / 非项目文件的 classpath 时会报
      -- "Referenced classpath provider does not exist: org.eclipse.buildship.core.classpathprovider"，
      -- 每次打开 Java 文件都会刷一屏。改由 <leader>dc 按需扫描。
      opts.dap_main = false

      -- =====================================================
      -- JVM HotSwap（方案 B）：debug session 中改方法体后自动 redefine
      -- java-debug-adapter 在 BUILD_COMPLETE 时发 redefineClasses 请求，
      -- 这里显式声明开关（LazyVim 默认也是 auto），便于一眼看到。
      -- 限制：只能改方法体；加字段/方法/类需方案 C（JRebel/HotswapAgent）。
      -- 手动兜底命令：:JdtUpdateHotcode（快捷键 <leader>dH）
      -- =====================================================
      opts.dap = opts.dap or {}
      opts.dap.hotcodereplace = "auto"

      opts.jdtls = opts.jdtls or {}

      opts.jdtls.settings = opts.jdtls.settings or {}
      opts.jdtls.settings.java = opts.jdtls.settings.java or {}

      -- =====================================================
      -- Gradle 自动刷新
      -- =====================================================

      opts.jdtls.settings.java.configuration = {
        updateBuildConfiguration = "automatic",
      }

      -- =====================================================
      -- 下载源码
      -- =====================================================

      opts.jdtls.settings.java.eclipse = {
        downloadSources = true,
      }

      opts.jdtls.settings.java.maven = {
        downloadSources = true,
      }

      -- =====================================================
      -- Inlay Hints
      -- =====================================================

      opts.jdtls.settings.java.inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      }

      -- =====================================================
      -- CodeLens
      -- =====================================================

      opts.jdtls.settings.java.implementationsCodeLens = {
        enabled = true,
      }

      opts.jdtls.settings.java.referencesCodeLens = {
        enabled = true,
      }

      -- =====================================================
      -- 保存自动整理 import
      -- =====================================================

      opts.jdtls.settings.java.saveActions = {
        organizeImports = true,
      }

      return opts
    end,
  },
}
