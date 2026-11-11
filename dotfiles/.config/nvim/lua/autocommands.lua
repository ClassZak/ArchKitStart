-- Force tabs
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function() vim.bo.expandtab = false end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.highlight.on_yank() end,
})

-- Quick fixes
vim.keymap.set('n', '<leader>qf', function()
	vim.lsp.buf.code_action({ context = { only = { 'quickfix' } }, apply = false })
end, { desc = 'Show quick fixes for current line' })

