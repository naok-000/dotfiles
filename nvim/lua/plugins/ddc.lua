return {
	{
		"Shougo/ddc.vim",
		lazy = false,
		dependencies = {
			"vim-denops/denops.vim",
			"Shougo/pum.vim",
			"Shougo/ddc-ui-pum",
			"Shougo/ddc-ui-native",
			"Shougo/ddc-source-around",
			"Shougo/ddc-file",
			"Shougo/ddc-source-lsp",
			"Shougo/ddc-filter-matcher_head",
			"Shougo/ddc-filter-sorter_rank",
			"Shougo/ddc-filter-converter_remove_overlap",
		},
		config = function()
			local fn = vim.fn
			local prev_buffer_config = nil

			fn["ddc#custom#patch_global"]({
				ui = "pum",
				autoCompleteEvents = { "InsertEnter", "TextChangedI", "TextChangedP" },
				sources = { "lsp", "around", "file" },
				sourceOptions = {
					["_"] = {
						ignoreCase = true,
						minAutoCompleteLength = 2,
						matchers = { "matcher_head" },
						sorters = { "sorter_rank" },
						converters = { "converter_remove_overlap" },
					},
					lsp = {
						mark = "[LSP]",
						dup = "keep",
					},
					around = { mark = "[A]" },
					file = {
						mark = "[F]",
						isVolatile = true,
						forceCompletionPattern = [[\S/\S*]],
					},
					skkeleton = {
						mark = "[SKK]",
						matchers = {},
						sorters = {},
						converters = {},
						isVolatile = true,
						minAutoCompleteLength = 1,
					},
					skkeleton_okuri = {
						mark = "[SKK*]",
						matchers = {},
						sorters = {},
						converters = {},
						isVolatile = true,
					},
				},
			})

			fn["ddc#enable"]()

			fn["pum#set_option"]({
				border = "rounded",
			})

			vim.keymap.set("i", "<C-Space>", function()
				fn["ddc#manual_complete"]()
			end, { silent = true, desc = "ddc manual complete" })
			vim.keymap.set("i", "<C-n>", "<Cmd>call pum#map#insert_relative(+1)<CR>", { silent = true })
			vim.keymap.set("i", "<C-p>", "<Cmd>call pum#map#insert_relative(-1)<CR>", { silent = true })
			vim.keymap.set("i", "<C-e>", "<Cmd>call pum#map#cancel()<CR>", { silent = true })
      vim.keymap.set("i", "<C-y>", "<Cmd>call pum#map#confirm()<CR>", { silent = true })

			local group = vim.api.nvim_create_augroup("DdcSkkeletonSwitch", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "skkeleton-enable-pre",
				callback = function()
					prev_buffer_config = fn["ddc#custom#get_buffer"]()
					fn["ddc#custom#patch_buffer"]({
						ui = "pum",
						autoCompleteEvents = { "InsertEnter", "TextChangedI", "TextChangedP" },
						sources = { "skkeleton", "skkeleton_okuri" },
					})
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "skkeleton-disable-pre",
				callback = function()
					if prev_buffer_config ~= nil then
						fn["ddc#custom#set_buffer"](prev_buffer_config)
					end
				end,
			})
		end,
	},
}
