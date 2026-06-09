return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	version = false,
	dependencies = {
		{
			"garymjr/nvim-snippets",
			opts = {
				friendly_snippets = true,
			},
			dependencies = { "rafamadriz/friendly-snippets" },
		}, -- Snippet Engine & its associated nvim-cmp source {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
		},
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	config = function()
		-- Register nvim-cmp lsp capabilities
		vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})
		local defaults = require("cmp.config.default")()
		local auto_select = true

		cmp.setup({
			auto_brackets = {},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			-- For an understanding of why these mappings were
			-- chosen, you will need to read `:help ins-completion`
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<leader>n"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<leader>p"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<leader>b"] = cmp.mapping.scroll_docs(-4),
				["<leader>f"] = cmp.mapping.scroll_docs(4),

				["<leader>y"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = auto_select }),

				["<leader>m"] = cmp.mapping.complete({}),
				["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				["<tab>"] = function(fallback)
					return vim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
				end,

				["<leader>l"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "nvim_lsp_signature_help" },
			}, {
				{ name = "buffer" },
			}),
			formatting = {
				format = function(entry, item)
					local icons = vim.config.icons.kinds
					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end

					local widths = {
						abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
						menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
					}

					for key, width in pairs(widths) do
						if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
							item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
						end
					end

					return item
				end,
			},
			experimental = {
				-- only show ghost text when we show ai completions
				ghost_text = vim.g.ai_cmp and {
					hl_group = "CmpGhostText",
				} or false,
			},
			sorting = defaults.sorting,
		})
	end,
}
