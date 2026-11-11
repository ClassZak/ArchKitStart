local M = {}

M.config = {
	include_chars = true,
	notify_level = vim.log.levels.INFO;
}


function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end


local function get_buffer_text()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	return table.concat(lines, "\n")
end


function M.count_words()
	local text = get_buffer_text()
	local count = 0
	for _ in text:gmatch("%S+") do
		count = count + 1
	end

	return count
end


function M.count_chars()
	return #get_buffer_text()
end




function M.show()
	local words = M.count_words()
	local msg
	if M.config.include_chars then
		msg = string.format("Words: %d, Chars: %d", words, M.count_chars())
	end

	vim.notify(msg, M.config.notify_level)
end


function M.statusline()
	return string.format("W:%d", M.count_words())
end




return M
