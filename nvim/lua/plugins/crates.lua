return {
  'saecki/crates.nvim',
  event = "BufRead Cargo.toml",
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local crates = require('crates')

    crates.setup({
      text = {
        loading = "  Loading...",
        version = "  %s",
        prerelease = "  %s",
        yanked = "  %s yanked",
        nomatch = "  Not found",
        upgrade = "  %s",
        error = "  Error fetching crate",
      },
      popup = {
        text = {
          title = "# %s",
          pill_left = "",
          pill_right = "",
          created_label = "created        ",
          updated_label = "updated        ",
          downloads_label = "downloads      ",
          homepage_label = "homepage       ",
          repository_label = "repository     ",
          documentation_label = "documentation  ",
          crates_io_label = "crates.io      ",
          categories_label = "categories     ",
          keywords_label = "keywords       ",
          version = "%s",
          prerelease = "%s pre-release",
          yanked = "%s yanked",
          enabled = "* s",
          transitive = "~ s",
          normal_dependencies_title = "  Dependencies",
          build_dependencies_title = "  Build dependencies",
          dev_dependencies_title = "  Dev dependencies",
          optional = "? %s",
          loading = " ...",
        },
      },
      src = {
        text = {
          prerelease = " pre-release ",
          yanked = " yanked ",
        },
      },
    })

    local wk = require("which-key")

    wk.register({
      t = { crates.toggle, "Toggle" },
      r = { crates.reload, "Reload" },
      v = { crates.show_versions_popup, "Show versions popup" },
      f = { crates.show_features_popup, "Show features popup" },
      d = { crates.show_dependencies_popup, "Show dependencies popup" },
      u = { crates.update_crate, "Update crate" },
      a = { crates.update_all_crates, "Update all crates" },
      U = { crates.upgrade_crate, "Upgrade crate" },
      A = { crates.upgrade_all_crates, "Upgrade all crates" },
      H = { crates.open_homepage, "Open homepage" },
      R = { crates.open_repository, "Open repository" },
      D = { crates.open_documentation, "Open documentation" },
      C = { crates.open_crates_io, "Open crates.io" },
    }, { prefix = "<leader>r", silent = true, desc = "Crates" })

    wk.register({
      u = { crates.update_crates, "Update crates" },
      U = { crates.upgrade_crates, "Upgrade crates" },
    }, { prefix = "<leader>r", silent = true, desc = "Crates", mode = 'v' })
  end
}
