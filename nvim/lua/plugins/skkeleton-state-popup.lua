return {
	"NI57721/skkeleton-state-popup",
	dependencies = { "vim-denops/denops.vim", "vim-skk/skkeleton" },
	enabled = false,
	config = function()
		vim.fn["skkeleton_state_popup#config"]({
			labels = {
				input = {
					hira = "あ",
					kata = "ア",
					hankata = "ｶﾅ",
					zenkaku = "Ａ",
				},

				["input:okurinasi"] = {
					hira = "▽▽",
					kata = "▽▽",
					hankata = "▽▽",
					abbrev = "ab",
				},

				["input:okuriari"] = {
					hira = "▽▽",
					kata = "▽▽",
					hankata = "▽▽",
				},

				henkan = {
					hira = "▼▼",
					kata = "▼▼",
					hankata = "▼▼",
					abbrev = "ab",
				},

				latin = "_A",
			},

			opts = {
				relative = "cursor",
				col = 0,
				row = 1,
				anchor = "NW",
				style = "minimal",
			},
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "skkeleton-initialize-post",
			callback = function()
				vim.fn["skkeleton_state_popup#run"]()
			end,
		})
	end,
}
