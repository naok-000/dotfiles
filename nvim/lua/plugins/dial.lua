return {
	"monaqa/dial.nvim",
	config = function()
		local augend = require("dial.augend")

		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.decimal_fraction.new({}),
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%m/%d"],
				augend.constant.alias.bool,
				augend.constant.alias.Bool,
				augend.constant.alias.alpha,
				augend.constant.alias.Alpha,
				augend.constant.alias.ja_weekday,
				augend.constant.alias.ja_weekday_full,
				augend.constant.new({
					elements = { "and", "or" },
					word = true,
				}),
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
				}),
			},
		})
	end,
	keys = {
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			mode = "n",
			desc = "Increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			mode = "n",
			desc = "Decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			mode = "n",
			desc = "Increment additively",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			mode = "n",
			desc = "Decrement additively",
		},
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "visual")
			end,
			mode = "x",
			desc = "Increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "visual")
			end,
			mode = "x",
			desc = "Decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gvisual")
			end,
			mode = "x",
			desc = "Increment additively",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gvisual")
			end,
			mode = "x",
			desc = "Decrement additively",
		},
	},
}
