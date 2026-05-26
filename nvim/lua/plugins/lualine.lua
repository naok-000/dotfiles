return {
	{
		"yasunori0418/statusline_skk.vim",
		lazy = false,
		enabled = false,
		dependencies = {
			"vim-skk/skkeleton",
		},
		config = function()
			vim.g.lightline_skk_announce = true
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- SKK表示を使うなら statusline_skk.vim を enabled = true にする
			-- "yasunori0418/statusline_skk.vim",
		},
		opts = function()
			local modus_operandi_tinted_lualine = {
				normal = {
					a = { fg = "#ffffff", bg = "#0031a9", gui = "bold" },
					b = { fg = "#0031a9", bg = "#e7e5eb" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				insert = {
					a = { fg = "#ffffff", bg = "#006800", gui = "bold" },
					b = { fg = "#006800", bg = "#dcebdc" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				visual = {
					a = { fg = "#ffffff", bg = "#721045", gui = "bold" },
					b = { fg = "#721045", bg = "#f0d3ff" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				replace = {
					a = { fg = "#ffffff", bg = "#a60000", gui = "bold" },
					b = { fg = "#a60000", bg = "#ffcccc" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				command = {
					a = { fg = "#ffffff", bg = "#005e8b", gui = "bold" },
					b = { fg = "#005e8b", bg = "#c6eaff" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				terminal = {
					a = { fg = "#ffffff", bg = "#8f0075", gui = "bold" },
					b = { fg = "#8f0075", bg = "#f8d8f8" },
					c = { fg = "#000000", bg = "#fbf7f0" },
				},
				inactive = {
					a = { fg = "#595959", bg = "#e7e5eb", gui = "bold" },
					b = { fg = "#595959", bg = "#e7e5eb" },
					c = { fg = "#595959", bg = "#fbf7f0" },
				},
			}

			return {
				options = {
					theme = modus_operandi_tinted_lualine,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			}
		end,
	},
}
-- メモ: 良さそうなlualineの設定例
-- https://github.com/naivecynics/primary-tmux/blob/f67cbc235ee9181e1fd1e9165cc58e5bca4eeaa2/lualine.lua
