if vim.g.loaded_word_count then
	return
end
vim.g.loaded_word_count = true


vim.api.nvim_create_user_command("WordCount", function()
	require("word-count").show()
end, { desc = "Show word/char count for current buffer" })
