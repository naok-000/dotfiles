-- tab, indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.g.markdown_recommended_style = 0

-- leader, bg
vim.g.mapleader = " "
vim.g.background = "dark"

-- don't create swp
vim.opt.swapfile = false

-- move between windows
-- vim.keymap.set("n", "<M-C-h>", "<C-w>h", { silent = true })
-- vim.keymap.set("n", "<M-C-j>", "<C-w>j", { silent = true })
-- vim.keymap.set("n", "<M-C-k>", "<C-w>k", { silent = true })
-- vim.keymap.set("n", "<M-C-l>", "<C-w>l", { silent = true })

-- delete highlight
vim.keymap.set("n", "<leader>h", "<Cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- line number
vim.opt.number = true
vim.opt.relativenumber = true

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- wrap line
vim.opt.wrap = false
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.showbreak = "↳ "
	end,
})

-- cursor line, column
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- auto read file when changed outside
vim.opt.autoread = true
