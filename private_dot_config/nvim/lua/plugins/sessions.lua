-- Saves window setup per-directory so that reopening nvim reopens the same window/tab setup it had when it was closed.
return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		post_restore_cmds = {
			function()
				for i = 1, vim.fn.tabpagenr("$") do
					vim.cmd("tabnext " .. (vim.fn.tabpagenr("$") + 1 - i)) -- Switch to tab `i`
					-- print(
					require("neo-tree.command").execute({
						action = "focus",
						source = "filesystem",
						position = "left",
						dir = vim.fn.getcwd(), -- Restore Neo-tree in the correct directory
					})
				end
			end,
		},
		-- log_level = 'debug',
	},
}
