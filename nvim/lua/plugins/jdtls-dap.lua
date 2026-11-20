-- jdtls 调试的 main-class 扫描治理。
--
-- 背景：java-debug 的 `vscode.java.resolveClasspath` 对 java-lab 里
-- java-basic/newFeature/8、21 这类独立 toolchain 子项目解析失败，报
-- "Referenced classpath provider does not exist: org.eclipse.buildship.core.classpathprovider"。
-- nvim-jdtls 的 fetch_main_configs 会遍历 workspace 所有 main class 逐个解析，
-- 于是一次扫描就把这些失败刷满屏——纯噪音，但很烦。
--
-- 三处一起治：
--   1) opts.dap_main=false —— 关掉 LspAttach 时的自动全量扫描；
--   2) 清掉 dap.providers.configs["jdtls"] —— 关掉 F5 / dap.continue 的自动发现扫描
--      （setup_dap 会注册它，其注释明说只有 setup_dap_main_class_configs 才负责清除）；
--   3) 重写 setup_dap_main_class_configs —— <leader>dc 走轻量路径，只解析当前类的
--      classpath，不再遍历所有子项目；拿不到当前类信息时回退到插件原实现，保证 dc 仍可用。
local M = {}

-- 常量：避免魔法值
local GRADLEW = "gradlew"
local JAVA_HOME_FALLBACK = "/Library/Java/JavaVirtualMachines/liberica-jdk-21.jdk/Contents/Home"
local GRADLE_MARKERS = { "build.gradle.kts", "build.gradle" }
local BIN_OUTPUTS = { "bin/main", "bin/test", "bin/default" }
local GRADLE_OUTPUTS = {
  "build/classes/java/main",
  "build/classes/java/test",
  "build/resources/main",
  "build/resources/test",
}

-- 从文件所在目录向上找最近的 gradle 模块根（含 build.gradle.kts/.gradle）
local function find_module_root(fname)
  local dir = vim.fn.fnamemodify(fname, ":p:h")
  while dir and dir ~= "/" and dir ~= "" do
    for _, marker in ipairs(GRADLE_MARKERS) do
      if vim.fn.filereadable(dir .. "/" .. marker) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- 找 gradlew：优先模块根向上到工程根
local function find_gradlew(module_root)
  local dir = module_root
  while dir and dir ~= "/" and dir ~= "" do
    local gw = dir .. "/" .. GRADLEW
    if vim.fn.executable(gw) == 1 then
      return gw
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- 在 gradle 输出里找 class：同时存在 resources/java，按 classpath 顺序过滤
local function build_gradle_classpaths(module_root)
  local cps = {}
  for _, rel in ipairs(GRADLE_OUTPUTS) do
    local p = module_root .. "/" .. rel
    if vim.fn.isdirectory(p) == 1 then
      table.insert(cps, p)
    end
  end
  return cps
end

-- 判断一个 classpath 条目是不是 jdtls 的 bin 输出，返回它对应的「模块根」。
-- 例如 <root>/dataAccess/mybatis-plus-demo/bin/main -> <root>/dataAccess/mybatis-plus-demo
local function bin_output_module(p)
  for _, b in ipairs(BIN_OUTPUTS) do
    local suffix = "/" .. b
    if p:sub(-#suffix) == suffix then
      local dir = p:sub(1, -#suffix - 1) -- 去掉 /bin/main 得到模块根
      -- 确认这个模块根确实是 gradle 模块（含 build.gradle.kts/.gradle）
      for _, marker in ipairs(GRADLE_MARKERS) do
        if vim.fn.filereadable(dir .. "/" .. marker) == 1 then
          return dir
        end
      end
      -- 是 bin 输出但不是已知 gradle 模块：仍视为 bin（避免残留），返回 nil 标记
      return false
    end
  end
  return nil
end

-- 把 resolveClasspath 返回的每条 bin 输出映射到「它自己模块」的 gradle 产物；
-- 映射不到就保留原 bin（绝不丢类，否则会 ClassNotFoundException）；依赖 jar 原样保留。
local function swap_bin_to_gradle(classpaths)
  local kept = {}
  for _, p in ipairs(classpaths or {}) do
    local bin_root = bin_output_module(p)
    if not bin_root then
      -- 非 bin 输出（依赖 jar / resources 等）原样保留；
      -- bin_root==false 表示是 bin 但找不到模块根，也保留以免丢类
      table.insert(kept, p)
    else
      local mapped = build_gradle_classpaths(bin_root)
      if #mapped > 0 then
        vim.list_extend(kept, mapped)
      else
        -- 该模块没有 gradle 产物，退回原 bin
        table.insert(kept, p)
      end
    end
  end
  -- 去重（同一模块可能映射出重复路径）
  local seen, uniq = {}, {}
  for _, p in ipairs(kept) do
    if not seen[p] then
      seen[p] = true
      table.insert(uniq, p)
    end
  end
  return uniq
end

-- 触发单模块 gradle 编译（同步，等待完成后再生成调试配置）
local function gradle_compile(module_root, gradlew)
  local java_home = vim.env.JAVA_HOME
  if not java_home or java_home == "" then
    java_home = JAVA_HOME_FALLBACK
  end
  local ok, handle = pcall(vim.system, {
    gradlew,
    "classes",
    "--console=plain",
    "-q",
  }, {
    cwd = module_root,
    env = { JAVA_HOME = java_home },
    text = true,
  })
  if not ok then
    return false, "gradle 编译调用失败: " .. tostring(handle)
  end

  -- nvim 0.10 的 wait() 返回 code(number)，0.11+ 返回 {code, stdout, stderr, signal}
  local waited = handle:wait()
  local code = type(waited) == "table" and waited.code or waited
  if code ~= 0 then
    local err = type(waited) == "table" and (waited.stderr or waited.stdout) or ""
    err = type(err) == "table" and table.concat(err, "\n") or (err or "")
    return false, "gradle 编译失败(exit " .. tostring(code) .. "): " .. err:sub(1, 300)
  end
  return true, nil
end

local function install()
  local ok_dap, dap = pcall(require, "dap")
  if not ok_dap then
    return
  end

  -- (2) F5 不再触发全量 main-class 发现
  if dap.providers and dap.providers.configs then
    dap.providers.configs["jdtls"] = nil
  end

  if M.installed then
    return
  end

  local ok_dap_mod, jdtls_dap = pcall(require, "jdtls.dap")
  local ok_util, util = pcall(require, "jdtls.util")
  if not (ok_dap_mod and ok_util) then
    return
  end

  local original = jdtls_dap.setup_dap_main_class_configs

  -- (3) 轻量版：只为当前 buffer 的 main 类生成一条 launch 配置。
  jdtls_dap.setup_dap_main_class_configs = function(opts, ...)
    local extra_args = { ... }
    opts = type(opts) == "table" and opts or {}
    local bufnr = vim.api.nvim_get_current_buf()
    local current_class = vim.fn.expand("%:t:r")
    local clients = util.get_clients({ bufnr = bufnr, name = "jdtls" })
    local root_dir = clients[1] and clients[1].config and clients[1].config.root_dir
    local on_ready = type(opts.on_ready) == "function" and opts.on_ready or function() end

    -- 拿不到当前类或 jdtls root 时，交给插件原实现兜底
    if current_class == "" or not root_dir then
      return original(opts, unpack(extra_args))
    end

    util.execute_command({ command = "vscode.java.resolveMainClass" }, function(err, mainclasses)
      if err or type(mainclasses) ~= "table" or #mainclasses == 0 then
        return original(opts, unpack(extra_args))
      end
      local target
      for _, mc in ipairs(mainclasses) do
        if type(mc.mainClass) == "string"
            and mc.mainClass:match("%." .. vim.pesc(current_class) .. "$") then
          target = mc
          break
        end
      end
      if not target then
        return original(opts, unpack(extra_args))
      end

      -- 只解析当前类的 classpath，其余子项目一概不碰，从根上杜绝刷屏
      util.execute_command(
        { command = "vscode.java.resolveClasspath", arguments = { target.mainClass, target.projectName } },
        function(err1, paths)
          if err1 or type(paths) ~= "table" then
            -- 当前类所在子项目本身就解析不了（如 8/21），不回退全量扫描（那样只会更糟）
            vim.notify("当前类无法解析 classpath，未生成调试配置", vim.log.levels.WARN)
            return on_ready()
          end

          -- 用 gradle 产物作为运行 classpath：先编译当前模块（classes 任务会连带
          -- 编译它依赖的 project，如 common-trace-spring-boot-starter），保证每个
          -- project 依赖都有自己的 build 产物，且 -parameters 等编译选项生效。
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local module_root = find_module_root(fname)
          local gradlew = module_root and find_gradlew(module_root) or nil
          local classpaths = paths[2]

          if module_root and gradlew then
            local compiled, cerr = gradle_compile(module_root, gradlew)
            if compiled then
              -- 逐条把 bin 输出映射到各自模块的 build 产物；映射不到则保留原 bin，
              -- 绝不丢类（starter 这类 project 依赖必须保留，否则 ClassNotFoundException）
              classpaths = swap_bin_to_gradle(paths[2])
            else
              vim.notify("改用 jdtls classpath（" .. (cerr or "未知原因") .. "）", vim.log.levels.WARN)
            end
          else
            vim.notify("未找到 gradle 模块/gradlew，沿用 jdtls classpath", vim.log.levels.WARN)
          end

          local config = {
            type = "java",
            name = "Launch " .. target.mainClass,
            request = "launch",
            mainClass = target.mainClass,
            projectName = target.projectName,
            cwd = root_dir,
            modulePaths = paths[1],
            classPaths = classpaths,
            console = "integratedTerminal",
          }
          config = vim.tbl_extend("force", config, opts.config_overrides or {})

          -- 保留非 launch 配置（<leader>da 依赖的 "Debug (Attach) - Remote"），
          -- 只替换 launch 项，避免破坏 HotSwap attach 流程
          local kept = {}
          for _, c in ipairs(dap.configurations.java or {}) do
            if c.request ~= "launch" then
              table.insert(kept, c)
            end
          end
          table.insert(kept, 1, config)
          dap.configurations.java = kept

          on_ready()
        end,
        bufnr
      )
    end, bufnr)
  end

  M.installed = true
end

-- 在 jdtls attach 之后装：此时 setup_dap 已注册 provider，jdtls.dap 也已加载。
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("jasper_java_dap_lightweight", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].filetype == "java" then
      vim.schedule(install)
    end
  end,
})

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.dap_main = false
      return opts
    end,
  },
}
