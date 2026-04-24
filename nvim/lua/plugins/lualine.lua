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
			"yasunori0418/statusline_skk.vim",
		},
		opts = function()
			local skk = function()
				return vim.fn["statusline_skk#mode"]()
			end

			return {
				options = {
					theme = "catppuccin",
				},
				sections = {
					lualine_a = { "mode" },
					-- lualine_b = { skk },
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
