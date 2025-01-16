local M = {}

function M.setup_lsps()
  local capabilities = M.get_capabilities()

  local lspconfig = require("lspconfig")

  lspconfig.csharp_ls.setup({
    capabilities = capabilities,
  })

  lspconfig.docker_compose_language_service.setup({
    capabilities = capabilities,
  })

  lspconfig.dockerls.setup({
    capabilities = capabilities,
  })

  lspconfig.yamlls.setup({
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/*.yaml",
          -- Add the schema for gitlab piplines
          -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.yml",
        },
      },
    },
  })

  lspconfig.solidity.setup({
    capabilities = capabilities,
    cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
    filetypes = { "solidity" },
    root_dir = lspconfig.util.root_pattern(".prettierrc"),
    single_file_support = true,
  })

  -- lspconfig.lemminx.setup({
  --   capabilities = capabilities,
  -- })

  -- lspconfig.jdtls.setup({
  --   capabilities = capabilities,
  -- })

  local lua_rtp = vim.split(package.path, ";")
  table.insert(lua_rtp, "lua/?.lua")
  table.insert(lua_rtp, "lua/?/init.lua")

  -- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = lua_rtp,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` and other globals
          globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
        },
        -- completion = { callSnippet = "Both" },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        workspace = {
          -- checkThirdParty = false,
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file("lua", true),
          library = {
            unpack(vim.api.nvim_get_runtime_file("", true)),
            -- unpack(vim.api.nvim_get_runtime_file("lua", true)),
            "${3rd}/luv/library",
            "${3rd}/busted/library",
          },
        },
        hint = {
          enable = true,
        },
      },
    },
  })

  lspconfig.bashls.setup({
    capabilities = capabilities,
    filetypes = { "sh", "bash", "zsh" },
  })

  -- local home = os.getenv("HOME")

  lspconfig.cssmodules_ls.setup({
    -- cmd = { "node", home .. "/repos/cssmodules-language-server/lib/cli.js" },
    capabilities = capabilities,
    -- on_attach = function(client, buf)
    --   client.server_capabilities.definitionProvider = false
    --   on_attach(client, buf)
    -- end,
    init_options = {
      camelCase = false,
    },
  })

  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    -- need to install previously:
    -- cmd = { "typescript-language-server", "--stdio" },
    -- disable_formatting = true,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  })

  lspconfig.cssls.setup({
    capabilities = capabilities,
  })

  lspconfig.html.setup({
    capabilities = capabilities,
  })

  lspconfig.pyright.setup({
    capabilities = capabilities,
  })

  lspconfig.jsonls.setup({
    capabilities = capabilities,
    init_options = {
      provideFormatter = true,
    },
    settings = {
      json = {
        format = "enable",
      },
    },
  })

  lspconfig.taplo.setup({})
end

---Ensure the installation of the following clis (whether they are lsps, linters, formatters or other tools)
---@param clis string[]
function M.ensure_installed(clis)
  local registry = require("mason-registry")

  for _, cli in ipairs(clis) do
    if not registry.is_installed(cli) then
      vim.cmd(":MasonInstall " .. cli)
    end
  end
end

function M.get_capabilities()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- allow lsps to make folding dynamic folding possible
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  return capabilities
end

return M
