--[[
    Neovim config: C/C++ debugging (single files, CMake), Python, Lua, SQL
    - Leader: space
    - LSP: clangd, pyright, lua_ls, sqls (Mason)
    - Debugging: nvim-dap (codelldb, debugpy, local-lua-debugger)
    - F5 – debug configuration selection menu
    - Clipboard: "+y, "+p, <leader>y, <leader>p
    - Russian keyboard layout (physical JCUKEN)
    - Highlighting: unique colors for all Treesitter groups (including Python, Lua, SQL)
    - Plugins: word occurrence highlighting, rainbow brackets
--]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end


require("base_settings")
require("file_associations")
require("backup")
require("encoding")
require("keymaps")
require("lazy_conf")
require("user_commands")
require("highlights")




print("Neovim config loaded: C/C++, Python, Lua, SQL – LSP, debugging, highlighting")
