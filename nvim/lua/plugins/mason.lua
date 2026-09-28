return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls" },
      -- kotlin_ls is configured by the kotlin.nvim plugin; don't also
      -- auto-enable the old fwcd kotlin-language-server from Mason.
      automatic_enable = {
        exclude = { "kotlin_language_server" },
      },
    })
  end,
}
