return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	--- Sometimes this doesn't work - might have to do
	--- cd ~/.local/share/nvim/lazy/markdown-preview.nvim && npm install
	--- 	(from https://github.com/iamcco/markdown-preview.nvim/issues/695)
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	keys = {
		{
			"<leader>mr",
			"<cmd>MarkdownPreview<CR>",
			ft = "markdown",
			desc = "Markdown Preview",
		},
		{
			"<leader>mx",
			"<cmd>MarkdownPreviewStop<CR>",
			ft = "markdown",
			desc = "Stop Markdown Preview",
		},
		{
			"<leader>mt",
			"<cmd>MarkdownPreviewToggle<CR>",
			ft = "markdown",
			desc = "Toggle Markdown Preview",
		},
	},
}
