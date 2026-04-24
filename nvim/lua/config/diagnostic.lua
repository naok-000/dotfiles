local float_opts = {
	border = "rounded",
}

vim.diagnostic.config({
	virtual_text = true,
	float = float_opts,
})

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float(nil, float_opts)
end, { desc = "Show diagnostics under cursor" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
