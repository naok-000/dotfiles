return {
	{
		"rebelot/kanagawa.nvim",

		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").load("wave")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 500,
		config = function()
			require("tokyonight").setup({
				style = "night",
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				vim.cmd.colorscheme("nightfox"),
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "darker",
			})
			require("onedark").load()
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		config = function()
			require("vscode").setup({
				style = "dark",
			})
			vim.cmd.colorscheme("vscode")
		end,
	},
	{
		"altercation/vim-colors-solarized",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "light"
			vim.cmd.colorscheme("solarized")
		end,
	},
	{
		"miikanissi/modus-themes.nvim",
		lazy = false,
		priority = 1,
		config = function()
			require("modus-themes").setup({
				style = "modus_operandi",
				variant = "tinted",
			})
			vim.cmd([[colorscheme modus]])
		end,
	},
}
