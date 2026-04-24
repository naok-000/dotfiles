if vim.g.vscode then
	return
end

local capabilities = require("ddc_source_lsp").make_client_capabilities()
local servers = {
	"solargraph",
	"html",
	"lua_ls",
	"clangd",
	"pyright",
	"ruff",
	"texlab",
	"gopls",
}

local group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

for _, server in ipairs(servers) do
	vim.lsp.config(server, { capabilities = capabilities })
end

vim.lsp.enable(servers)
