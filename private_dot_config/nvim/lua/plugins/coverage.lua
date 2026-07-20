return {
	"andythigpen/nvim-coverage",
	version = "*",
	rocks = { "lua-xmlreader" },

	config = function()
		local cs_coverage = vim.fs.find("cs_coverage", {
			path = vim.fn.getcwd(),
			type = "directory",
			limit = 1,
		})[1]

		require("coverage").setup({
			auto_reload = true,
			lang = cs_coverage and { cs = {
				coverage_file = cs_coverage .. "/lcov.info",
			} } or {},
		})

		vim.keymap.set("n", "<leader>ct", "<ESC>:CoverageToggle<CR>", {
			desc = "Toggle coverage",
		})

		vim.keymap.set("n", "<leader>cr", "<ESC>:CoverageLoad<CR>", {
			desc = "Reload coverage",
		})

		-- vim.keymap.set("n", "<leader>cs", "<ESC>:CoverageSummary<CR>", {
		-- 	desc = "Coverage summary",
		-- })
		vim.keymap.set("n", "<leader>cs", function()
			require("coverage").load()
			require("coverage").summary()
		end, {
			desc = "Load coverage and show summary",
		})
	end,
}
