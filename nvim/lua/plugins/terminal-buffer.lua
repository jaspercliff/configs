-- 像普通 buffer 一样占满编辑区的终端
-- 与 toggleterm 并存：toggleterm 用 <C-\>（浮动），本方案用 <leader>tc（占满编辑区）
--
-- 用原生 terminal buffer，不经过 Snacks 的窗口管理：
-- Snacks 的 fixbuf autocmd 会在 BufWinEnter 时强行把窗口换回终端 buffer，
-- 与切换操作形成 nvim_win_set_buf 递归（E218: Autocommand nesting too deep）。
local LEADER_TC = "<leader>bt"
local TERM_FT = "snacks_terminal" -- 沿用主题已有的终端高亮，保证透明背景一致
local SHELL_CMD = vim.o.shell

local M = {}

--- 终端 buffer 的编号，跨切换复用同一个 shell
local term_buf = nil
--- 进入终端前所在的 buffer，供 toggle 精确切回
local return_buf = nil

local function is_valid(buf)
  return buf ~= nil and vim.api.nvim_buf_is_valid(buf)
end

--- 确保存在一个存活的终端 buffer，并返回它
local function ensure_term_buf()
  if is_valid(term_buf) then
    return term_buf
  end

  -- 在当前窗口打开原生终端（term 会在当前 buffer 位置创建）
  vim.cmd.terminal(SHELL_CMD)
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].filetype = TERM_FT
  -- 固定：进 bufferline、可被 bufnext/bprevious 识别、切走后 shell 不中断
  vim.bo[buf].buflisted = true
  vim.bo[buf].bufhidden = "hide"
  term_buf = buf
  return buf
end

--- 在「当前文件」与「终端」之间一键往返
function M.toggle()
  local cur = vim.api.nvim_get_current_buf()

  -- 当前在终端：切回进入终端前的文件（没有则用上一个 buffer）
  if is_valid(term_buf) and cur == term_buf then
    if is_valid(return_buf) and return_buf ~= cur then
      vim.api.nvim_set_current_buf(return_buf)
    else
      vim.cmd("buffer #")
    end
    return
  end

  -- 当前在文件：记住它，再切到终端
  return_buf = cur
  local buf = ensure_term_buf()
  vim.api.nvim_set_current_buf(buf)
  vim.cmd("startinsert")
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        LEADER_TC,
        M.toggle,
        mode = { "n", "t" },
        desc = "Toggle terminal (as buffer)",
      },
    },
  },
}
