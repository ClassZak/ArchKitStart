vim.api.nvim_create_user_command('SpacesDoubleToQuadruple', '%s/ \\{2\\}/		/g', {})
vim.api.nvim_create_user_command('SpacesDoubleToTabs', '%s/ \\{2\\}/\\t/g', {})
vim.api.nvim_create_user_command('SpacesToTabs', '%s/ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('SpacesToTabsFirst', '%s/^ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('SaveNoEOL', function()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if #lines > 0 and lines[#lines] == '' then
		table.remove(lines)
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.cmd('write')
end, {})
vim.api.nvim_create_user_command('ReopenCP1251', 'e ++enc=cp1251', {})
vim.api.nvim_create_user_command('ClipboardCurrBuffer', 'write ! wl-copy', {})

