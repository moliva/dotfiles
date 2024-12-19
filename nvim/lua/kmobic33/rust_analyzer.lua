local settings = {
  ['rust-analyzer'] = {
    -- server = {
    --   path = '/Users/moliva/.cargo/bin/ra-multiplex'
    -- },
    -- enable clippy on save
    -- checkOnSave = {
    --   command = "clippy",
    -- },
    check = {
      command = "clippy",
    },
    -- cargo = {
    --   allFeatures = true,
    -- },
    diagnostics = {
      enable = true,
      disabled = { "unresolved-proc-macro" },
      enableExperimental = true,
    },
    inlayHints = {
      bindingModeHints = {
        enable = true
      },
      chainingHints = {
        enable = true
      },
      closingBraceHints = {
        enable = true
      },
      closureReturnTypeHints = {
        enable = true
      },
    }
  }
  -- rust-analyzer.inlayHints.bindingModeHints.enable (default: false)
  -- Whether to show inlay type hints for binding modes.
  --
  -- rust-analyzer.inlayHints.chainingHints.enable (default: true)
  -- Whether to show inlay type hints for method chains.
  --
  -- rust-analyzer.inlayHints.closingBraceHints.enable (default: true)
  -- Whether to show inlay hints after a closing  to indicate what item it belongs to.
  --
  -- rust-analyzer.inlayHints.closingBraceHints.minLines (default: 25)
  -- Minimum number of lines required before the } until the hint is shown (set to 0 or 1 to always show them).
  --
  -- rust-analyzer.inlayHints.closureReturnTypeHints.enable (default: "never")
  -- Whether to show inlay type hints for return types of closures.
  --
  -- rust-analyzer.inlayHints.closureStyle (default: "impl_fn")
  -- Closure notation in type and chaining inaly hints.
  --
  -- rust-analyzer.inlayHints.discriminantHints.enable (default: "never")
  -- Whether to show enum variant discriminant hints.
  --
  -- rust-analyzer.inlayHints.expressionAdjustmentHints.enable (default: "never")
  -- Whether to show inlay hints for type adjustments.
  --
  -- rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe (default: false)
  -- Whether to hide inlay hints for type adjustments outside of unsafe blocks.
  --
  -- rust-analyzer.inlayHints.expressionAdjustmentHints.mode (default: "prefix")
  -- Whether to show inlay hints as postfix ops (. instead of , etc).
  --
  -- rust-analyzer.inlayHints.lifetimeElisionHints.enable (default: "never")
  -- Whether to show inlay type hints for elided lifetimes in function signatures.
  --
  -- rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames (default: false)
  -- Whether to prefer using parameter names as the name for elided lifetime hints if possible.
  --
  -- rust-analyzer.inlayHints.maxLength (default: 25)
  -- Maximum length for inlay hints. Set to null to have an unlimited length.
  --
  -- rust-analyzer.inlayHints.parameterHints.enable (default: true)
  -- Whether to show function parameter name inlay hints at the call site.
  --
  -- rust-analyzer.inlayHints.reborrowHints.enable (default: "never")
  -- Whether to show inlay hints for compiler inserted reborrows. This setting is deprecated in favor of rust-analyzer.inlayHints.expressionAdjustmentHints.enable.
  --
  -- rust-analyzer.inlayHints.renderColons (default: true)
  -- Whether to render leading colons for type hints, and trailing colons for parameter hints.
  --
  -- rust-analyzer.inlayHints.typeHints.enable (default: true)
  -- Whether to show inlay type hints for variables.
  --
  -- rust-analyzer.inlayHints.typeHints.hideClosureInitialization (default: false)
  -- Whether to hide inlay type hints for let statements that initialize to a closure. Only applies to closures with blocks, same as rust-analyzer.inlayHints.closureReturnTypeHints.enable.
  --
  -- rust-analyzer.inlayHints.typeHints.hideNamedConstructor (default: false)
  -- Whether to hide inlay type hints for constructors.
}

local M = {}

function M.config(capabilities)
  return {
    capabilities = capabilities,
    cmd = {
      "rust-analyzer"
      -- "rustup", "run", "stable", "rust-analyzer"
      -- "ra-multiplex", "--ra-mux-server", "/Users/moliva/.rustup/toolchains/stable-x86_64-apple-darwin/bin/rust-analyzer"
    },
    settings = settings
  }
end

return M
