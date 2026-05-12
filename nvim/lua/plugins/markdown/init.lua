return {
  --实时渲染markdown
  require("plugins.markdown.render-markdown"),
  -- 浏览器渲染 eg：mermaid
  require("plugins.markdown.live-preview"),
  -- paste image in asstes
  require("plugins.markdown.img-clip"),
  -- 1. 输完自动是2.  无序列表也是一样
  require("plugins.markdown.bullets"),
}
