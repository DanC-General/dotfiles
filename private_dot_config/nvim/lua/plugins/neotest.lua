return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",

			-- Treesitter
			"nvim-treesitter/nvim-treesitter",

			-- Adapter
			"Issafalcon/neotest-dotnet",
		},

		config = function()
			local neotest = require("neotest")

			neotest.setup({
				adapters = {
					require("neotest-dotnet")({
						dap = false,
					}),
				},
			})

			local map = vim.keymap.set

			map("n", "<leader>tx", function()
				neotest.run.run()
			end, { desc = "Nearest test" })

			map("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Test file" })

			map("n", "<leader>ta", function()
				neotest.run.run(vim.fn.getcwd())
			end, { desc = "All tests" })

			map("n", "<leader>tl", function()
				neotest.output.open({ enter = true })
			end, { desc = "Output" })

			map("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "Summary" })

			-- map("n", "<leader>tl", function()
			-- 	neotest.run.run_last()
			-- end, { desc = "Last test" })
		end,
	},
}
