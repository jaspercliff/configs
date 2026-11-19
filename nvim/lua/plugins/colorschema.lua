-- 主题配置（catppuccin）
-- 主编辑区/浮窗透明以透出 kitty 的壁纸；状态栏/光标行/选区保留淡色块，避免视觉丢失
local CATPPUCCIN = "catppuccin"
local FLAVOUR = "mocha" -- 与 kitty 的 Catppuccin-Mocha 主题保持一致

return {
  {
    "catppuccin/nvim",
    name = CATPPUCCIN,
    priority = 1000,
    lazy = false,
    opts = {
      flavour = FLAVOUR,
      transparent_background = true,
      float = {
        transparent = true, -- Telescope / which-key 等浮窗也透出壁纸
      },
      integrations = {
        blink_cmp = true,
        lualine = {
          -- 状态栏保留实色，避免壁纸亮区导致文字看不清
          all = function(colors)
            return {
              normal = { c = { bg = colors.mantle } },
              inactive = {
                a = { bg = colors.mantle },
                b = { bg = colors.mantle },
                c = { bg = colors.mantle },
              },
            }
          end,
        },
      },
      highlight_overrides = {
        all = function(colors)
          return {
            -- 当前行/选区保留淡色块，透明时才能看出光标位置
            CursorLine = { bg = colors.surface0 },
            CursorLineNr = { bg = colors.surface0 },
            Visual = { bg = colors.surface1 },
            VertSplit = { fg = colors.surface1 },
          }
        end,
      },
    },
  },

  -- LazyVim 加载该主题（用带 flavour 的完整名，确保透明选项被应用）
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = CATPPUCCIN .. "-" .. FLAVOUR,
    },
  },
}
