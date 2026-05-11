return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				style = {
					{ fg = "#b4befe" },
					{ fg = "#fab387" },
				},
				duration = 100,
				delay = 100,
			},
			indent = {
				enable = true,
			},
			line_num = {
				enable = true,
			},
		})
	end,
}
