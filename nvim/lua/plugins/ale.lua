return {
	{
		"dense-analysis/ale",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
      vim.g.ale_disable_lsp = 1
			vim.g.ale_lint_on_enter = 0
			vim.g.ale_lint_on_filetype_changed = 0
			vim.g.ale_lint_on_text_changed = "never"
			vim.g.ale_lint_on_insert_leave = 0
			vim.g.ale_lint_on_save = 1
			vim.g.ale_echo_msg = 0
			vim.g.ale_echo_msg_format = ""
			vim.g.ale_echo_cursor = 0
			vim.g.ale_linters = {
				markdown = { "textlint" },
				text = { "textlint" },
				tex = { "textlint" },
        go = { "golangci-lint" },
			}
		end,
	},
}
