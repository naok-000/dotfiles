return {
	"nvim-neo-tree/neo-tree.nvim",
  enabled = false,
	opts = {
		window = {
			position = "right",
		},
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
	},
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	lazy = false, -- neo-tree will lazily load itself
	config = function()
		vim.keymap.set("n", "<C-n>", "<Cmd>Neotree reveal right<CR>")
		vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle right<CR>")
		vim.keymap.set("n", "<leader>bf", "<Cmd>Neotree buffers reveal float<CR>")
	end,
}
