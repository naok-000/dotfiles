return {
	{
		"vim-skk/skkeleton",
		dependencies = { "vim-denops/denops.vim" },
		config = function()
			local is_darwin = (vim.uv or vim.loop).os_uname().sysname == "Darwin"
			local global_dictionaries

			if is_darwin then
				global_dictionaries = {
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.china_taiwan"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.edict"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.fullname"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.geo"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.itaiji"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.itaiji.JIS3_4"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.jinmei"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.JIS2"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.JIS2004"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.JIS3_4"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.law"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.mazegaki"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.office.zipcode"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.okinawa"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.propernoun"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.station"
					),
					vim.fn.expand(
						"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.zipcode"
					),
				}
			else
				global_dictionaries = {
					vim.fn.expand("~/.local/share/skk/SKK-JISYO.geo"),
					vim.fn.expand("~/.local/share/skk/SKK-JISYO.jinmei"),
					vim.fn.expand("~/.local/share/skk/SKK-JISYO.L"),
					vim.fn.expand("~/.local/share/skk/SKK-JISYO.law"),
					vim.fn.expand("~/.local/share/skk/SKK-JISYO.propernoun"),
				}
			end

			local skkeleton_config = {
				globalDictionaries = global_dictionaries,
				completionRankFile = vim.fn.expand("~/.local/share/skk/rank.json"),
				eggLikeNewline = true,
        markerHenkan = "",
        markerHenkanSelect = "",
			}
			if is_darwin then
				skkeleton_config.userDictionary = vim.fn.expand(
					"~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/skk-jisyo.utf8"
				)
			end

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
