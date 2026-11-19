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
          local config = {
            type = "java",
            name = "Launch " .. target.mainClass,
            request = "launch",
            mainClass = target.mainClass,
            projectName = target.projectName,
            cwd = root_dir,
            modulePaths = paths[1],
            classPaths = paths[2],
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
