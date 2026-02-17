--  git diffview
return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-tree/nvim-web-devicons", -- 需要图标支持
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true, -- 更好的高亮
      use_icons = true, -- 显示图标
      view = {
        merge_tool = {
          layout = "diff3_mixed", -- 经典三栏合并布局
        },
      },
    })
  end,
}
