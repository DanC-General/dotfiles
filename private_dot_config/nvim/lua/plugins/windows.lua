return {
	"yorickpeterse/nvim-window",
	keys = {
		{ "<leader>j", "<cmd>lua require('nvim-window').pick()<cr>", desc = "Jump to window" },
	},
	config = true,
	render = "status",
}
