return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup({
				controls = {
					element = "console",
				},
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.4,
							},
							{
								id = "breakpoints",
								size = 0.3,
							},
							{
								id = "stacks",
								size = 0.3,
							},
							-- {
							-- 	id = "watches",
							-- 	size = 0.25,
							-- },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{
								id = "console",
							},
							-- {
							-- 	id = "console",
							-- 	size = 0.5,
							-- },
						},
						position = "top",
						size = 1,
					},
				},
			})

			require("nvim-dap-virtual-text").setup({
				-- -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				-- display_callback = function(variable)
				-- 	local name = string.lower(variable.name)
				-- 	local value = string.lower(variable.value)
				-- 	-- if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
				-- 	-- 	return "*****"
				-- 	-- end
				--
				-- 	if #variable.value > 15 then
				-- 		return " " .. string.sub(variable.value, 1, 15) .. "... "
				-- 	end
				--
				-- 	return " " .. variable.value
				-- end,
			})

			local netcoredbg = vim.fn.exepath("netcoredbg")
			if netcoredbg ~= "" then
				dap.adapters.coreclr = {
					type = "executable",
					command = netcoredbg,
					args = {
						"--interpreter=vscode",
					},
					env = {
						-- TODO: These don't seem to apply
						ASPNETCORE_ENVIRONMENT = function()
							return "Development"
						end,
						ASPNETCORE_URLS = function()
							return "http://localhost:7009"
						end,
					},
				}

				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "launch - netcoredbg",
						request = "launch",
						program = function()
							return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
						end,
					},
					{
						type = "coreclr",
						name = "attach - netcoredbg",
						request = "attach",
						processId = "${command:pickProcess}",
					},
				}
			end

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
