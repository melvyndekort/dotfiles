-- Bootstrap Lazy if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Enable filetype detection, plugins, and indentation
vim.cmd([[
  filetype plugin indent on
]])

-- Load plugins from external file
require("plugins")

-- Additional settings not covered by vim-sensible
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

-- Keybindings for Telescope
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>Telescope tags<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope resume<cr>", { noremap = true, silent = true })

-- Bufferline keybindings
vim.api.nvim_set_keymap("n", "<leader>bc", ":BufferLinePick<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bn", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
