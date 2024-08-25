return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},

	config = function()
		local lspcfg = require("lspconfig")
		local mason_lspcfg = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local km = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),

			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				--km.set("n", "gD", vim.lsp.buf.declaration, opts)
				km.set("n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)

				opts.desc = "Show LSP definitions"
				km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				km.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				km.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				km.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				km.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				km.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				km.set("n", "Jd", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				km.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				km.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = "E", Warn = "W", Hints = "H", Info = "I" }

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspcfg.setup_handlers({
			function(server_name)
				lspcfg[server_name].setup({
					capabilities = capabilities,
				})
			end,
			-- example config if u need special lsp configuration
			-- ["svelte"] = function()
			--    lspcfg["svelte"].setup({
			--       capabilities = capabilities,
			--       on_attach = function(client, bufnr)
			--          vim. api.nvim_create_autocmd("BufWritePost", {
			--             pattern = { "*.js", "*.ts" },
			--             callback = function(ctx)
			--                   client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			--             end,
			--          })
			--       end
			--    })
			-- end

			["lua_ls"] = function()
				lspcfg["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completition = {
								callSnippets = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
