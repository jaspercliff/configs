-- 对 yaml/properties 文件生效的 spring-boot 补全源
return {
  "hrsh7th/nvim-cmp",
  optional = true,
  opts = function(_, opts)
    local cmp = require("cmp")
    cmp.register_source("spring-boot", require("java-helper.spring_cmp").new())

    -- 只在 yaml/properties 文件启用
    local source = { name = "spring-boot" }
    local ft_override = {
      yaml = { source },
      properties = { source },
    }
    -- LazyVim 的 cmp 支持 filetype 级别的 sources
    -- 直接把 source 放到全局 sources 也能用，spring_cmp 内部会自己过滤文件类型
    table.insert(opts.sources, 1, source)
  end,
}
