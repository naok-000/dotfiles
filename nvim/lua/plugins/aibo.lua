return {
	"lambdalisue/nvim-aibo",
  enabled = false,
	config = function()
		local default_tool = "codex"
		local aibo_opener = "botright vsplit"
		local console = require("aibo.internal.console_window")
		local prompt = require("aibo.internal.prompt_window")
		local aibo_command = require("aibo.command.aibo")

		require("aibo").setup({
			tools = {
				codex = {
					on_attach = function(bufnr, info)
						-- Open diff jumps in the current window instead of tabdrop.
						if info.type == "console" then
							vim.keymap.set("n", "<Plug>(aibo-jump)", "<Plug>(aibo-jump:edit)", {
								buffer = bufnr,
								remap = true,
							})
						end
					end,
				},
			},
		})

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				silent = true,
				desc = desc,
			})
		end

		local function get_relative_path()
			local path = vim.fn.expand("%:.")
			if path == "" then
				return "[No Name]"
			end
			return path
		end

		local function get_visual_selection_info()
			local start_pos = vim.fn.getpos("v")
			local end_pos = vim.fn.getpos(".")

			if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
				start_pos, end_pos = end_pos, start_pos
			end

			local text = table.concat(
				vim.fn.getregion(start_pos, end_pos, {
					type = vim.fn.mode(),
					exclusive = vim.o.selection == "exclusive",
				}),
				"\n"
			)

			return {
				start_line = start_pos[2],
				end_line = end_pos[2],
				text = text,
			}
		end

		local function ensure_console_window()
			local console_info = console.find_info_in_tabpage()
			if not console_info then
				console_info = console.find_info_globally({ cmd = default_tool })
			end

			if console_info then
				local current_tab = vim.api.nvim_get_current_tabpage()
				local is_visible_in_current_tab = console_info.winid ~= -1
					and vim.api.nvim_win_is_valid(console_info.winid)
					and vim.api.nvim_win_get_tabpage(console_info.winid) == current_tab

				if not is_visible_in_current_tab then
					vim.cmd(string.format("%s %s", aibo_opener, vim.fn.fnameescape(console_info.bufname)))
					console_info = console.get_info_by_winid(vim.api.nvim_get_current_win())
				end
			else
				aibo_command.call({ default_tool }, { opener = aibo_opener })
				console_info = console.get_info_by_winid(vim.api.nvim_get_current_win())
			end

			return console_info
		end

		local function ensure_prompt_window()
			local prompt_info = prompt.find_info_in_tabpage()
			if prompt_info and vim.api.nvim_win_is_valid(prompt_info.winid) then
				return prompt_info
			end

			local console_info = ensure_console_window()
			if not console_info or not vim.api.nvim_win_is_valid(console_info.winid) then
				return nil
			end

			return prompt.open(console_info.winid, {})
		end

		local function focus_prompt(winid)
			if not vim.api.nvim_win_is_valid(winid) then
				return
			end

			vim.api.nvim_set_current_win(winid)
			vim.cmd("startinsert")
		end

		local function send_to_prompt(text)
			local info = ensure_prompt_window()
			if not info then
				return
			end

			prompt.write(info.bufnr, vim.split(text, "\n", { plain = true }))
			focus_prompt(info.winid)
		end

		local function toggle_aibo()
			aibo_command.call({ default_tool }, {
				opener = aibo_opener,
				toggle = true,
				stay = true,
			})
		end

		local function build_current_line_reference()
			return string.format("%s:%d", get_relative_path(), vim.fn.line("."))
		end

		local function build_visual_snippet()
			local selection = get_visual_selection_info()
			return string.format(
				"```%s:%d-%d\n%s\n```",
				get_relative_path(),
				selection.start_line,
				selection.end_line,
				selection.text
			)
		end

		-- sidekick-compatible mappings
		map({ "n", "t", "i", "x" }, "<C-.>", toggle_aibo, "[aibo] Toggle default CLI")

		map("n", "<leader>at", function()
			send_to_prompt(build_current_line_reference())
		end, "[aibo] Send file:line")

		map("x", "<leader>av", function()
			local text = build_visual_snippet()
			send_to_prompt(text)
		end, "[aibo] Send fenced snippet")
	end,
}
