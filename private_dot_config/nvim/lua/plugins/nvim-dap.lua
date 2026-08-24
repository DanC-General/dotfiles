return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			"jay-babu/mason-nvim-dap.nvim",
			"williamboman/mason.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"nicholasmata/nvim-dap-cs",
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>ds",
				function()
					require("dap").continue()
				end,
				desc = "Continue / Start Debugging",
			},
			{
				"Up",
				function()
					require("dap").continue()
				end,
				desc = "Step Out",
			},
			{
				"<Down>",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<Right>",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate Session",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debugger UI",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local helpers = require("helpers")

			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "cs", "c", "rust" },
				automatic_installation = true,
			})
			require("lazydev").setup({
				library = { "nvim-dap-ui" },
			})
			require("nvim-dap-virtual-text").setup({})
			require("dap-cs").setup({
				netcoredbg = {
					path = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
				},
			})

			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations = {
				cs = {
					{
						type = "coreclr",
						name = "Launch Root",
						request = "launch",
						program = function()
							return helpers.select_dll(helpers.project_root("%.csproj$")) or dap.ABORT
						end,
					},
				},
				rust = {
					{
						name = "Launch",
						type = "codelldb",
						request = "launch",
						program = function()
							local exe_dir = helpers.project_root("target") .. "/debug"
							local find_exe_str = string.format("find %s -maxdepth 1 -type f -executable", exe_dir)
							local exe = helpers.file_selection(find_exe_str, {
								empty_message = "No executable files found in " .. exe_dir,
								multiple_title_message = "Select project:",
								allow_multiple = false,
							})

							return exe
						end,
					},
				},
			}
			-- Optional: Style the breakpoint icons in the gutter
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped", linehl = "Visual", numhl = "" })
		end,
	},
}
