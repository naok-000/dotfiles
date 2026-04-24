return {
	"refractalize/oil-git-status.nvim",

	dependencies = {
		"stevearc/oil.nvim",
	},

	opts = {},
	config = function()
		require("oil-git-status").setup({
			show_ignored = false,
			symbols = { -- customize the symbols that appear in the git status columns
				index = {
					["!"] = "!",
					["?"] = "?",
					["A"] = "A",
					["C"] = "C",
					["D"] = "D",
					["M"] = "M",
					["R"] = "R",
					["T"] = "T",
					["U"] = "U",
					[" "] = " ",
				},
				working_tree = {
					["!"] = "!",
					["?"] = "?",
					["A"] = "A",
					["C"] = "C",
					["D"] = "D",
					["M"] = "M",
					["R"] = "R",
					["T"] = "T",
					["U"] = "U",
					[" "] = " ",
				},
			},
		})
	end,
}
