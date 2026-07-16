-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Исправление для Foot и Wayland
vim.opt.shell = '/bin/bash'
vim.opt.shellcmdflag = '-c'
vim.opt.shellredir = '2>&1'  -- Важно для Foot!

vim.opt.relativenumber = false
