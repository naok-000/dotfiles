return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-lua/plenary.nvim",
		"amansingh-afk/milli.nvim",
	},

	config = function()
		local alpha = require("alpha")
		local theta = require("alpha.themes.theta")
		local milli = require("milli")
		local splash = "badge"
		local splash_data = milli.load({ splash = splash })

		-- local ascii = require("ascii")
		--
		-- theta.header.val = ascii.get_random("text", "neovim")
		theta.header.val = splash_data.frames[1]
		alpha.setup(theta.config)
		milli.alpha({ data = splash_data, loop = true })
	end,
}
