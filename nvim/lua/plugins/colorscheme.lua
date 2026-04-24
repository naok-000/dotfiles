return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 100,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
        transparent_background = true,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = { "italic" },
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = { "italic" },
					operators = {},
				},
				lsp_styles = {
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				auto_integrations = false,
				integrations = {
					alpha = true,
					cmp = true,
					gitsigns = true,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					noice = true,
          notify = true,
					copilot_vim = true,
					snacks = {
						enabled = true,
						indent_scope_color = "lavender",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
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
}
