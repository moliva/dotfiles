local M = {}

local wezterm = require("wezterm")

function M.is_dark()
  return wezterm.gui.get_appearance():find("Dark")
end

-- TODO - use this  in a fzf an select presentation mode or sth - moliva - 2025/02/11
function M.get_presentation_theme()
  return {
    color_scheme = nil,
    background = {
      color = "black",
      opacity = 1,
    },
  }
end

function M.get_theme()
  return M.is_dark()
      and {
        color_scheme = "Harmonic16 Dark (base16)",
        background = {
          color = "#0b1c2c",
          opacity = 0.95,
        },
      }
    or {
      color_scheme = "Harmonic16 Light (base16)",
      background = {
        color = "#92bfe8",
        opacity = 0.9,
      },
    }
end

return M
