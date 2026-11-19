-- 修复 Neovim 0.11+/0.12 跳转到 jar 内 class（jdt:// URI）时的
-- "Invalid cursor line: out of range" 报错。
--
-- 根因：vim.lsp.buf.definition / references 的 handler 会调用
-- vim.lsp.util.locations_to_items，后者为了填充 quickfix 的 text 字段，
-- 会对 jdt:// 这类自定义 scheme 执行 bufload。bufload 触发 nvim-jdtls 的
-- BufReadCmd -> open_classfile，其内部用 vim.wait 阻塞等待反编译结果；
-- 而 vim.wait 会 flush vim.schedule 队列，导致外层设置光标的回调在
-- 反编译内容写入 buffer 之前运行，目标行号超出当前 buffer 行数而报错。
--
-- 处理分两层：
-- 1. 在 locations_to_items 之前同步预加载 jdt:// buffer，消除 bufload 重入；
-- 2. 对 nofile 虚拟 buffer 的越界行号做 clamp，作为兜底防御。

local api = vim.api
local lsp_util = vim.lsp.util

local JDT_URI_SCHEME = "jdt://"
local NOFILE_BUFTYPE = "nofile"
local MIN_CURSOR_LINE = 1

local native_locations_to_items = lsp_util.locations_to_items
local native_set_cursor = api.nvim_win_set_cursor

--- 提前同步加载 jdt:// buffer，使 locations_to_items 内部的 bufload 不再触发 BufReadCmd 重入。
---@param locations table
local function preload_jdt_buffers(locations)
  for _, location in ipairs(locations or {}) do
    local uri = location.uri or location.targetUri
    if type(uri) == "string" and vim.startswith(uri, JDT_URI_SCHEME) then
      local bufnr = vim.uri_to_bufnr(uri)
      if vim.fn.bufloaded(bufnr) ~= 1 then
        -- jdtls 尚未就绪时 bufload 可能抛错，内容缺失由下面的光标 clamp 兜底
        pcall(vim.fn.bufload, bufnr)
      end
    end
  end
end

lsp_util.locations_to_items = function(locations, offset_encoding)
  preload_jdt_buffers(locations)
  return native_locations_to_items(locations, offset_encoding)
end

---@param bufnr integer
---@return boolean
local function is_virtual_buffer(bufnr)
  return api.nvim_buf_is_valid(bufnr)
    and api.nvim_buf_get_option(bufnr, "buftype") == NOFILE_BUFTYPE
end

api.nvim_win_set_cursor = function(win, pos)
  local ok, bufnr = pcall(api.nvim_win_get_buf, win)
  if ok and is_virtual_buffer(bufnr) then
    local line_count = api.nvim_buf_line_count(bufnr)
    if pos[1] > line_count then
      pos = { math.max(MIN_CURSOR_LINE, line_count), pos[2] }
    end
  end
  return native_set_cursor(win, pos)
end
