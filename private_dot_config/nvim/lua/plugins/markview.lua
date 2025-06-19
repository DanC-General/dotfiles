return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	preview = {
		icon_provider = "internal", -- "mini" or "devicons"
	},
	-- This was to disable the signs showing up, but horizontal_rules didn't seem to be disableable.
	-- Ended up using the nuclear option and just disabling the sign column entirely.
	--
	-- opts = {
	-- 	-- 	markdown = {
	-- 	--
	-- 	-- 	}
	-- 	headings = {
	-- 		heading_1 = { sign = "" },
	-- 		heading_2 = { sign = "" },
	-- 		heading_3 = { sign = "" },
	-- 		heading_4 = { sign = "" },
	-- 		heading_5 = { sign = "" },
	-- 		heading_6 = { sign = "" },
	-- 	},
	--
	-- 	code_blocks = {
	-- 		sign = false,
	-- 	},
	-- 	markdown = {
	-- 		list_items = {
	-- 			sign = "",
	-- 		},
	-- 		block_quotes = {
	-- 			sign = "",
	-- 		},
	-- 		code_blocks = {
	-- 			sign = "",
	-- 		},
	-- 		headings = {
	-- 			sign = "",
	-- 		},
	-- 		horizontal_rules = {
	-- 			sign = false,
	-- 		},
	-- 		tables = {
	-- 			sign = "",
	-- 		},
	-- 	},
	-- },
	config = function(_, opts)
		require("markview").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.wo.signcolumn = "no"
			end,
		})
	end,
	ft = { "markdown" },
	-- For blink.cmp's completion
	-- source
	-- dependencies = {
	--     "saghen/blink.cmp"
	-- },
}
