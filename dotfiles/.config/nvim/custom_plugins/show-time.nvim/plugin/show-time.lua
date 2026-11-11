if vim.g.loaded_show_time then
	return
end
vim.g.loaded_show_time = true

vim.api.nvim_create_user_command("DateTime", function()
	require("show-time").show_date_time()
end, { desc = "Show current date and time" })
