-- Saves window setup per-directory so that reopening nvim reopens the same window/tab setup it had when it was closed.
return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/Downloads" },
		close_unsupported_windows = true,

		autosave_ignore_buftypes = {
			"quickfix",
			"nofile",
			"prompt",
			"neo-tree",
			"neotree",
		},
		autosave_ignore_filetypes = {
			"dapui_scopes",
			"dapui_stacks",
			"dapui_breakpoints",
			"dapui_watches",
			"dap-repl",
			"neo-tree",
			"neotree",
		},
		bypass_session_save_file_types = { "neo-tree", "neotree" },
	},
}
