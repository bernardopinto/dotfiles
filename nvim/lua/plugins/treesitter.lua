-- nvim-treesitter's `main` branch: `setup()` only takes `install_dir`, parsers
-- are installed explicitly and highlighting is enabled per filetype.
-- Building parsers needs `tree-sitter-cli` (see Brewfile) and a C compiler.
local languages = { "lua", "scala" }

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
      -- pcall: the parser may still be installing on first start
      callback = function() pcall(vim.treesitter.start) end,
    })
  end,
}
