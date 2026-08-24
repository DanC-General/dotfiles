return {
	-- dir = "~/projects/Personal/Plugins/simple-cov",
	"DanC-General/simple-cov",
	config = function()
		require("coverage").setup({})
		vim.keymap.set("n", "<leader>as", require("coverage").show)
		vim.keymap.set("n", "<leader>ag", require("coverage").generate)
	end,
}
