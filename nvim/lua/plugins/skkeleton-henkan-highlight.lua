return {
	"NI57721/skkeleton-henkan-highlight",
	dependencies = { "vim-denops/denops.vim", "vim-skk/skkeleton" },
	config = function()
		local function set_highlights()
			vim.cmd([[
				highlight SkkeletonHenkan gui=underline term=underline cterm=underline
				highlight SkkeletonHenkanSelect gui=underline,reverse term=underline,reverse cterm=underline,reverse
			]])
		end

		local group = vim.api.nvim_create_augroup("skkeleton_henkan_highlight", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = group,
			callback = set_highlights,
		})

		set_highlights()
	end,
}
