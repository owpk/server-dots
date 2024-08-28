return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mfussenegger/nvim-jdtls", -- java support
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

			["jdtls"] = function()
				local home = os.getenv("HOME")
				if vim.fn.has("mac") == 1 then
					WORKSPACE_PATH = home .. "/workspace/"
					CONFIG = "mac"
				elseif vim.fn.has("unix") == 1 then
					WORKSPACE_PATH = home .. "/workspace/"
					CONFIG = "linux"
				else
					print("Unsupported system")
				end

				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				local workspace_dir = WORKSPACE_PATH .. project_name

				lspcfg["jdtls"].setup({
					cmd = {

						-- 💀
						"java", -- or '/path/to/java11_or_newer/bin/java'
						-- depends on if `java` is in your $PATH env variable and if it points to the right version.

						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
						"-Xms1g",
						"--add-modules=jdk.incubator.vector",
						"--add-modules=ALL-SYSTEM",
						"--add-opens",
						"java.base/java.util=ALL-UNNAMED",
						"--add-opens",
						"java.base/java.lang=ALL-UNNAMED",

						-- 💀
						"-jar",
						vim.fn.glob(
							home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
						),
						-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
						-- Must point to the                                                     Change this to
						-- eclipse.jdt.ls installation                                           the actual version

						-- 💀
						"-configuration",
						home .. "/.local/share/nvim/mason/share/jdtls/config_" .. CONFIG,
						-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
						-- Must point to the                      Change to one of `linux`, `win` or `mac`
						-- eclipse.jdt.ls installation            Depending on your system.

						-- 💀
						-- See `data directory configuration` section in the README
						"-data",
						workspace_dir,
					},

					--on_attach = require("user.lsp.handlers").on_attach,
					capabilities = capabilities,

					-- 💀
					-- This is the default if not provided, you can remove it. Or adjust as needed.
					-- One dedicated LSP server & client will be started per unique root_dir
					root_dir = function()
						vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
					end,

					-- Here you can configure eclipse.jdt.ls specific settings
					-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
					-- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
					-- for a list of options
					settings = {
						java = {
							-- jdt = {
							--   ls = {
							--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
							--   }
							-- },
							eclipse = {
								downloadSources = true,
							},
							configuration = {
								updateBuildConfiguration = "interactive",
							},
							maven = {
								downloadSources = true,
							},
							implementationsCodeLens = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
							},
							references = {
								includeDecompiledSources = true,
							},
							inlayHints = {
								parameterNames = {
									enabled = "all", -- literals, all, none
								},
							},
							format = {
								enabled = false,
							},
						},
						signatureHelp = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*",
							},
						},
						contentProvider = { preferred = "fernflower" },
						--extendedClientCapabilities = extendedClientCapabilities,
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
							useBlocks = true,
						},
					},

					flags = {
						allow_incremental_sync = true,
					},

					init_options = {
						bundles = {},
					},
				})
			end,
		})
	end,
}
