-- Keep private vault locations out of the repo.
local vault_path = vim.env.OBSIDIAN_VAULT_PATH

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	enabled = vault_path ~= nil,
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "obsidian",
				path = vault_path,
			},
		},
		notes_subdir = "notes",
		new_notes_location = "notes_subdir",
		note_id_func = function(title)
			local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
			if not vim.g.obsidian_random_seeded then
				math.randomseed(os.time() + math.floor(vim.uv.hrtime() % 1000000))
				vim.g.obsidian_random_seeded = true
			end

			local slug = (title or "note"):lower()
			slug = slug:gsub("%s+", "-"):gsub("[^a-z0-9-]", ""):gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
			if slug == "" then
				slug = "note"
			end

			local suffix = {}
			for _ = 1, 6 do
				local i = math.random(#chars)
				suffix[#suffix + 1] = chars:sub(i, i)
			end

			return string.format("%s-%s", slug, table.concat(suffix))
		end,
		daily_notes = {
			folder = "notes/daily",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = nil,
		},

		-- see below for full list of options 👇
	},
}
