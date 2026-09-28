return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "light"
    require("gruvbox").setup({
      overrides = {
        MatchParen = { fg = "#282828", bg = "#fabd2f", bold = true },
      },
    })
    vim.cmd.colorscheme("gruvbox")
  end,
}
