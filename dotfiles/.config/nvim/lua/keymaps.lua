-- Russian keyboard layout (JCUKEN)
vim.opt.langmap = 'ФИСВУАПРШОЛДЖЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKL:MNOPQRSTUVWXYZ,фисвуапршолджьтщзйкыегмцчня;abcdefghijkl:mnopqrstuvwxyz'

------------------------------------------------------------------------------
-- 2. MAPPINGS
------------------------------------------------------------------------------
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>t', '<cmd>bnext<CR>')
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Upper window' })
map('n', '<C-Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<C-S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })
map('n', '[g', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
map('n', ']g', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix' })

-- Clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
map({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

