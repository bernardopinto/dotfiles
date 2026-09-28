return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "lua", "scala" },
      auto_install = true,
      ignore_install = { "javascript" },
    })
  end,
}
