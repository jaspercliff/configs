return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
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
