return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	preview = {
		icon_provider = "internal", -- "mini" or "devicons"
	},
	opts = {
		-- 	markdown = {
		--
		-- 	}
		headings = {
			heading_1 = { sign = "" },
			heading_2 = { sign = "" },
			heading_3 = { sign = "" },
			heading_4 = { sign = "" },
			heading_5 = { sign = "" },
			heading_6 = { sign = "" },
		},

		code_blocks = {
			sign = false,
		},
	},
	config = function(_, opts)
		require("markview").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.wo.signcolumn = "auto"
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
