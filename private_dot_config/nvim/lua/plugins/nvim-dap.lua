local number_indices = function(array)
	local result = {}
	for i, value in ipairs(array) do
		result[i] = i .. ": " .. value
	end
	return result
end

local display_options = function(prompt_title, options)
	local display = number_indices(vim.deepcopy(options))
	table.insert(display, 1, prompt_title)

	local choice = vim.fn.inputlist(display)

	if choice > 0 then
		return options[choice]
	else
		return nil
	end
end

local file_selection = function(cmd, opts)
	local results = vim.fn.systemlist(cmd)

	if #results == 0 then
		print(opts.empty_message)
		return
	end

	if opts.allow_multiple then
		return results
	end

	local result = results[1]
	if #results > 1 then
		result = display_options(opts.multiple_title_message, results)
	end

	return result
end

local project_selection = function(project_path, allow_multiple)
	local check_csproj_cmd = string.format('find %s -type f -name "*.csproj"', project_path)
	local project_file = file_selection(check_csproj_cmd, {
		empty_message = "No csproj files found in " .. project_path,
		multiple_title_message = "Select project:",
		allow_multiple = allow_multiple,
	})
	return project_file
end

local select_dll = function(project_path)
	if project_path == nil then
		return
	end

	local bin_path = project_path .. "/bin"
	local check_net_folders_cmd = string.format('find %s -type d -name "net*"', bin_path)

	local net_bin = file_selection(check_net_folders_cmd, {
		empty_message = 'No dotnet directories found in the "bin" directory. Ensure project has been built.',
		multiple_title_message = "Select NET Version:",
	})
	if net_bin == nil then
		return
	end

	local project_file = project_selection(project_path)
	if project_file == nil then
		return
	end
	local project_name = vim.fn.fnamemodify(project_file, ":t:r")

	local dll_name = project_name .. ".dll"
	local dll_cmd = string.format('find "%s" -type f -iname "%s"', net_bin .. "/", dll_name)
	local dll = file_selection(dll_cmd, {
		empty_message = "No dlls could be found.",
		multiple_title_message = "Select DLL",
	})
	return dll
end

-- Searches the fs upwards for a directory containing the expected path regex.
-- If the match is a file, returns the enclosing directory.
-- If the match is a directory, returns it.
-- e.g. dotnet projects expect a .csproj file at the project root.
local project_root = function(entry_re)
	local target = vim.fs.find(function(name)
		return name:match(entry_re)
	end, {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})[1]

	local project_dir
	if target then
		if vim.fn.isdirectory(target) == 1 then
			project_dir = target
		elseif vim.fn.filereadable(target) == 1 then
			project_dir = vim.fs.dirname(target)
		else
			vim.notify("Target exists but is unknown:", target)
			return nil
		end
	else
		vim.notify("Failed to find any upper directory containing " .. entry_re)
		return nil
	end

	return project_dir
end

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
							return select_dll(project_root("%.csproj$")) or dap.ABORT
						end,
					},
				},
				rust = {
					{
						name = "Launch",
						type = "codelldb",
						request = "launch",
						program = function()
							local exe_dir = project_root("Cargo.toml") .. "/target/debug"
							local find_exe_str = string.format("find %s -maxdepth 1 -type f -executable", exe_dir)
							local exe = file_selection(find_exe_str, {
								empty_message = "No executable files found in " .. exe_dir,
								multiple_title_message = "Select project:",
								allow_multiple = allow_multiple,
							})

							return exe
						end,
						stopOnEntry = false,
					},
				},
			}
			-- Optional: Style the breakpoint icons in the gutter
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped", linehl = "Visual", numhl = "" })
		end,
	},
}
