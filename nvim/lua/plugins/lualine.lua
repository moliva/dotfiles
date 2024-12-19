return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "RRethy/nvim-base16" },
    config = function()
      require("nvim-web-devicons").setup()

      -- require('nvim-base16').setup()
      vim.cmd("colorscheme base16-harmonic-dark")
      -- vim.cmd('colorscheme base16-tomorrow-night')
      -- vim.cmd("hi NormalNC ctermbg=NONE guibg=NONE")

      local current_git_repo = nil

      local function repository_name()
        -- this might not be a git repository
        if current_git_repo then
          return current_git_repo
        end

        local handle = io.popen([[. ~/current_git_repo]])
        local result = handle:read("*a")
        handle:close()

        current_git_repo = result:sub(1, #result - 1)

        return current_git_repo
      end

      local function maximize_status()
        return vim.t.maximized and "   " or ""
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          -- theme = "base16",
          theme = "rose-pine-alt",
          -- theme = "rose-pine",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          -- lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_b = { repository_name, "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
            {
              maximize_status,
            },
            -- {
            --   'bg_jobs',
            --   on_click = function(clicks, button, modifiers)
            --     RELOAD('mappings').show_background_jobs()
            --   end,
            -- },
          },
          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
