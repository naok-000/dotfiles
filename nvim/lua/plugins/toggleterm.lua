local lazygit_term

local function toggle_lazygit()
	local Terminal = require("toggleterm.terminal").Terminal
	if not lazygit_term then
		lazygit_term = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})
	end
	lazygit_term:toggle()
end

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 20,
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		float_opts = {
			border = "rounded",
			winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
		},
	},
	keys = {
		{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
		{ "<leader>tg", toggle_lazygit, desc = "Toggle lazygit" },
		{ "<Esc><Esc>", [[<C-\><C-n>]], mode = "t", desc = "Exit terminal mode" },
	},
}
