return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  -- rustaceanvim ships its own ftplugin/rust.lua, so lazy.nvim should not
  -- wrap it with additional lazy-loading. See the plugin README.
  lazy = false,
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            cargo = { features = "all" },
            inlayHints = {
              lifetimeElisionHints = { enable = "skip_trivial" },
              closureReturnTypeHints = { enable = "with_block" },
            },
          },
        },
      },
    }
  end,
}
