local M = {}

M.config = {
	os_date_format = "%d.%m.%Y %H:%M:%S"
}




function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end






function M.show_date_time()
	local msg
	msg = string.format("%s", os.date(M.config.os_date_format))

	vim.notify(msg, vim.log.levels.INFO)
end


function M.statusline()
	return string.format("W:%d", M.count_words())
end




return M
