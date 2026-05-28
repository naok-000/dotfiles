return {
	{
		"vim-skk/skkeleton",
		dependencies = { "vim-denops/denops.vim" },
		config = function()
			local global_dictionaries = vim.split(vim.env.SKK_GLOBAL_DICTIONARIES or "", ":", {
				plain = true,
				trimempty = true,
			})

			local skkeleton_config = {
				globalDictionaries = global_dictionaries,
				completionRankFile = vim.fn.expand("~/.local/share/skk/rank.json"),
				eggLikeNewline = true,
				markerHenkan = "",
				markerHenkanSelect = "",
				userDictionary = vim.env.SKK_USER_DICTIONARY,
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
