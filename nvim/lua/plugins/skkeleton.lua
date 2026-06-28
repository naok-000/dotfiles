return {
	{
		"vim-skk/skkeleton",
		dependencies = { "vim-denops/denops.vim" },
		config = function()
			local skk_dir = vim.fn.expand("~/.local/skk")

			local skkeleton_config = {
				globalDictionaries = {
					skk_dir .. "/SKK-JISYO.L",
					skk_dir .. "/SKK-JISYO.itaiji",
					skk_dir .. "/SKK-JISYO.itaiji.JIS3_4",
					skk_dir .. "/SKK-JISYO.JIS2",
					skk_dir .. "/SKK-JISYO.JIS2004",
					skk_dir .. "/SKK-JISYO.JIS3_4",
					skk_dir .. "/SKK-JISYO.law",
					skk_dir .. "/SKK-JISYO.mazegaki",
					skk_dir .. "/SKK-JISYO.geo",
					skk_dir .. "/SKK-JISYO.station",
					skk_dir .. "/SKK-JISYO.zipcode",
					skk_dir .. "/SKK-JISYO.office.zipcode",
					skk_dir .. "/SKK-JISYO.china_taiwan",
					skk_dir .. "/SKK-JISYO.okinawa",
					skk_dir .. "/SKK-JISYO.edict",
					skk_dir .. "/SKK-JISYO.propernoun",
					skk_dir .. "/SKK-JISYO.jinmei",
					skk_dir .. "/SKK-JISYO.fullname",
				},
				completionRankFile = skk_dir .. "/rank.json",
				eggLikeNewline = true,
				markerHenkan = "",
				markerHenkanSelect = "",
				userDictionary = skk_dir .. "/skk-jisyo.utf8",
			}

			vim.fn["skkeleton#config"](skkeleton_config)

			vim.api.nvim_create_augroup("skkeleton_user_config", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				group = "skkeleton_user_config",
				pattern = "skkeleton-initialize-pre",
				callback = function()
					vim.fn["skkeleton#register_kanatable"]("rom", {
						[","] = { "，", "" },
						["."] = { "．", "" },
						["("] = { "（", "" },
						[")"] = { "）", "" },
					})
				end,
			})

			-- keybindings
			vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(skkeleton-enable)", { noremap = true })
			vim.api.nvim_set_keymap("c", "<C-j>", "<Plug>(skkeleton-enable)", { noremap = true })
			vim.api.nvim_set_keymap("t", "<C-j>", "<Plug>(skkeleton-enable)", { noremap = true })
		end,
	},
}
