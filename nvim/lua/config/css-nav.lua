-- CSS 类名双向导航：纯配置实现，不依赖额外插件。
-- gd：在模板文件（tsx/jsx/html/vue）的类名上跳到 CSS 定义
-- gr：在 CSS 类名上查看模板文件里的使用位置

local M = {}

local CSS_FILETYPES = { "css", "scss", "less", "sass" }
local SOURCE_FILETYPES = { "typescriptreact", "javascriptreact", "html", "vue", "svelte", "astro" }
local CSS_EXTENSIONS = { "css", "scss", "less", "sass" }
local SOURCE_EXTENSIONS = { "html", "htm", "jsx", "tsx", "vue", "svelte", "astro" }
local ROOT_MARKERS = { "package.json", ".git" }
local EXCLUDED_GLOBS = { "!node_modules/**", "!dist/**", "!build/**" }

local DEFINITION_TITLE = "CSS class definitions"
local REFERENCES_TITLE = "CSS class usages"
local CLASS_ATTRIBUTE = "class"
local SELECTOR_PREFIX = "."
local WORD_CHAR = "[%w_-]"

local function add_glob_args(args, extensions)
  for _, extension in ipairs(extensions) do
    table.insert(args, "--glob")
    table.insert(args, "*." .. extension)
  end
  for _, glob in ipairs(EXCLUDED_GLOBS) do
    table.insert(args, "--glob")
    table.insert(args, glob)
  end
end

local function parse_vimgrep(stdout, root)
  local items = {}
  for line in vim.gsplit(stdout, "\n") do
    local filename, lnum, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
    if filename then
      -- rg 输出的是相对它自己 cwd 的路径，这里转成绝对路径
      local absolute = filename:match("^/") and filename or vim.fs.joinpath(root, filename)
      table.insert(items, {
        filename = vim.fs.normalize(absolute),
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end
  return items
end

local function run_rg(pattern, extensions)
  local root = vim.fs.root(0, ROOT_MARKERS) or vim.fn.getcwd()
  local args = { "rg", "--vimgrep", "--color", "never", "--no-messages", "--fixed-strings" }
  add_glob_args(args, extensions)
  table.insert(args, "--")
  table.insert(args, pattern)
  table.insert(args, ".")

  local result = vim.system(args, { cwd = root, text = true }):wait()
  -- rg 的退出码 1 表示没有匹配，不算错误
  if result.code > 1 then
    return {}
  end
  return parse_vimgrep(result.stdout, root)
end

local function class_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local start_col = col
  local end_col = col

  -- 不依赖 iskeyword，手工按类名字符集向两侧扩展
  while start_col > 1 and line:sub(start_col - 1, start_col - 1):match(WORD_CHAR) do
    start_col = start_col - 1
  end
  while end_col <= #line and line:sub(end_col + 1, end_col + 1):match(WORD_CHAR) do
    end_col = end_col + 1
  end

  local word = line:sub(start_col, end_col)
  if word == "" then
    return nil
  end
  return word
end

local function is_boundary(char)
  return char == "" or not char:match(WORD_CHAR)
end

local function has_token(text, token)
  local from = 1
  while true do
    local start_pos, end_pos = text:find(token, from, true)
    if not start_pos then
      return false
    end
    local prev = text:sub(start_pos - 1, start_pos - 1)
    local next = text:sub(end_pos + 1, end_pos + 1)
    if is_boundary(prev) and is_boundary(next) then
      return true
    end
    from = end_pos + 1
  end
end

local function open_results(items, title, jump_on_single)
  if #items == 0 then
    return false
  end
  if jump_on_single and #items == 1 then
    local item = items[1]
    vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    return true
  end
  vim.fn.setqflist({}, " ", { title = title, items = items })
  vim.cmd("copen")
  return true
end

local function fallback_definition()
  pcall(vim.lsp.buf.definition)
end

local function fallback_references()
  pcall(vim.lsp.buf.references)
end

function M.definition()
  local class = class_under_cursor()
  if not class then
    fallback_definition()
    return
  end

  local selector = SELECTOR_PREFIX .. class
  local items = vim.tbl_filter(function(item)
    local next_pos = item.col + #selector
    return is_boundary(item.text:sub(next_pos, next_pos))
  end, run_rg(selector, CSS_EXTENSIONS))

  if not open_results(items, DEFINITION_TITLE .. ": " .. class, true) then
    fallback_definition()
  end
end

function M.references()
  local class = class_under_cursor()
  if not class then
    fallback_references()
    return
  end

  local items = vim.tbl_filter(function(item)
    return has_token(item.text, class)
  end, run_rg(CLASS_ATTRIBUTE, SOURCE_EXTENSIONS))

  if not open_results(items, REFERENCES_TITLE .. ": " .. class, false) then
    fallback_references()
  end
end

function M.definition_keymap()
  if vim.list_contains(SOURCE_FILETYPES, vim.bo.filetype) then
    M.definition()
  else
    pcall(vim.lsp.buf.definition)
  end
end

function M.references_keymap()
  if vim.list_contains(CSS_FILETYPES, vim.bo.filetype) then
    M.references()
  else
    pcall(vim.lsp.buf.references)
  end
end

return M
