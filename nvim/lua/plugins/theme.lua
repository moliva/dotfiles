return {
  -- theme & ui
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VeryLazy",
    config = function()
      -- scheme: "Harmonic16 Dark"
      -- author: "Jannik Siebert (https://github.com/janniks)"

      require("rose-pine").setup({
        dim_inactive_windows = true,

        palette = {
          -- https://rosepinetheme.com/palette/ingredients/

          -- Override the builtin palette per variant
          --     moon = {
          --       _nc = "#1f1d30",
          --       base = "#232136",
          --       surface = "#2a273f",
          --       overlay = "#393552",
          --       muted = "#6e6a86",
          --       subtle = "#908caa",
          --       text = "#e0def4",
          --       love = "#eb6f92",
          --       gold = "#f6c177",
          --       rose = "#ea9a97",
          --       pine = "#3e8fb0",
          --       foam = "#9ccfd8",
          --       iris = "#c4a7e7",
          --       leaf = "#95b1ac",
          --       highlight_low = "#2a283e",
          --       highlight_med = "#44415a",
          --       highlight_high = "#56526e",
          --       none = "NONE",
          --
          --       _nc = "#0b1c2c",
          --       base = "#223b54",
          --       surface = "#2a273f",
          --       overlay = "#405c79",
          --       muted = "#627e99",
          --       subtle = "#aabcce",
          --       text = "#cbd6e2",
          --       love = "#e5ebf1",
          --       gold = "#f7f9fb",
          --       rose = "#bf8b56",
          --       pine = "#bfbf56",
          --       foam = "#568bbf",
          --       iris = "#568bbf",
          --       leaf = "#8b56bf",
          --       highlight_low = "#bf568b",
          --       highlight_med = "#bf5656",
          --       highlight_high = "#56526e",
          --       none = "NONE",
          -- -- base00: "0b1c2c"
          -- -- base01: "223b54"
          -- -- base02: "405c79"
          -- -- base03: "627e99"
          -- -- base04: "aabcce"
          -- -- base05: "cbd6e2"
          -- -- base06: "e5ebf1"
          -- -- base07: "f7f9fb"
          -- -- base08: "bf8b56"
          -- -- base09: "bfbf56"
          -- -- base0A: "8bbf56"
          -- -- base0B: "56bf8b"
          -- -- base0C: "568bbf"
          -- -- base0D: "8b56bf"
          -- -- base0E: "bf568b"
          -- -- base0F: "bf5656"
          --     },
        },

        highlight_groups = {
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        },
      })
    end,
  },
}
