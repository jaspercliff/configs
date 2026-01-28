return {
  "nvim-java/nvim-java",
  config = function()
    require("java").setup({
      -- 插件自身的配置
      jdtls = {
        settings = {
          java = {
            -- 开启 Maven 自动下载源码和 Javadoc
            maven = {
              downloadSources = true,
              downloadJavadocs = true,
            },
            -- 开启 Gradle 自动下载源码
            eclipse = {
              downloadSources = true,
            },
            -- 允许自动更新构建配置
            configuration = {
              updateBuildConfiguration = "interactive",
            },
          },
        },
      },
    })
  end,
}
