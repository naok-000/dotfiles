return {
	"github/copilot.vim",

	cond = function()
		-- vscodeでは無効化
		if vim.g.vscode then
			return false
		end

		-- COPILOT_VIM_DISABLED が設定されていない場合にのみプラグインを有効化
		local plugin_disabled = os.getenv("COPILOT_VIM_DISABLED")
		if not plugin_disabled then
			return true
		else
			return false
		end
	end,
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.api.nvim_set_keymap(
			"i",
			"<C-K>",
			'copilot#Accept("<CR>")',
			{ expr = true, replace_keycodes = false, silent = true }
		)
		vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
		vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)")
	end,
}
