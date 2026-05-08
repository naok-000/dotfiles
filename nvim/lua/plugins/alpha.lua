return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local alpha = require("alpha")
		local theta = require("alpha.themes.theta")
    local ascii = require("ascii")

		theta.header.val = ascii.get_random("text", "neovim")
		alpha.setup(theta.config)
	end,
}
