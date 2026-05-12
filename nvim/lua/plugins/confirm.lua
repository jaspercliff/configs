return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
      json = { "jq" },
    },
    formatters = {
      ["google-java-format"] = {
        -- 加上这个参数，缩进就变成 4 空格，和 IDEA 默认一致
        prepend_args = { "--aosp" },
      },
    },
  },
}
