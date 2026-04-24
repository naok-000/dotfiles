return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	init = function()
		if vim.env.TMUX and #vim.env.TMUX > 0 then
			vim.g.smart_splits_multiplexer_integration = "tmux"
		end
	end,
	config = function()
		local smart_splits = require("smart-splits")

		smart_splits.setup({})

		vim.keymap.set("n", "<M-C-h>", smart_splits.move_cursor_left, { desc = "Move to left split" })
		vim.keymap.set("n", "<M-C-j>", smart_splits.move_cursor_down, { desc = "Move to lower split" })
		vim.keymap.set("n", "<M-C-k>", smart_splits.move_cursor_up, { desc = "Move to upper split" })
		vim.keymap.set("n", "<M-C-l>", smart_splits.move_cursor_right, { desc = "Move to right split" })

		vim.keymap.set("n", "<M-h>", smart_splits.resize_left, { desc = "Resize split left" })
		vim.keymap.set("n", "<M-j>", smart_splits.resize_down, { desc = "Resize split down" })
		vim.keymap.set("n", "<M-k>", smart_splits.resize_up, { desc = "Resize split up" })
		vim.keymap.set("n", "<M-l>", smart_splits.resize_right, { desc = "Resize split right" })
	end,
}
