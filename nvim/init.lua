vim.g.mapleader = " "

vim.wo.number = true
vim.o.termguicolors = true
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- Start with all folds open; toggle with za, close all with zM, open all with zR
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Loading core settings first
require("config.keymaps")
-- plugins
require("lazy").setup("plugins")

-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

