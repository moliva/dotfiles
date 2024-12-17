local M = {}

function M.get_current_opacity(window)
  local overrides = window:effective_config()
  local backgrounds = overrides.background or {}
  local background = backgrounds[0] or {}

  return background.opacity or window:effective_config().background[1].opacity
end

function M.change_opacity(window, amount)
  local current_opacity = M.get_current_opacity(window)

  local effective_background = window:effective_config().background[1]

  local new_opacity = current_opacity + amount > 1 and 1
    or (current_opacity + amount < 0 and 0 or current_opacity + amount)

  local new_overrides = {
    background = {
      {
        source = effective_background.source,
        width = effective_background.width,
        height = effective_background.height,
        opacity = new_opacity,
      },
    },
  }

  window:set_config_overrides(new_overrides)
end

return M
