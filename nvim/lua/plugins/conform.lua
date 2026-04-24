return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			-- lua/plugins/conform.lua 等
			local conform = require("conform")
			local util = require("conform.util")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					c = { "clang_format" },
					cpp = { "clang_format" },
					markdown = { "prettier", stop_after_first = true },
					tex = { "latexindent" },
					bib = { "bibtex-tidy" },
					nix = { "alejandra" },
					go = { "gofmt", "goimports" },
				},

				formatters = {
					latexindent = {
						cwd = util.root_file({ ".latexindent.yaml", ".git" }),

						prepend_args = function(_, ctx)
							local sw = vim.bo[ctx.buf].shiftwidth
							if sw == 0 then
								sw = vim.bo[ctx.buf].tabstop
							end
							local indent = vim.bo[ctx.buf].expandtab and string.rep(" ", sw) or "\t"

							return {
								"-c",
								"$DIRNAME/",
								"-m",
								"-l=.latexindent.yaml",
								("-y=defaultIndent: '%s'"):format(indent),
							}
						end,
					},
				},
			})
		end,
		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ async = true })
		end, { desc = "Format file with conform.nvim" }),
	},
}
