return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",

	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"json",
				"yaml",
				"html",
				"css",
				"markdown",
				"vim",
				"graphql",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"ini",

				"sql",
				"nix",
				"lua",
				"groovy",
				"bash",
				"java",
				"kotlin",
				"go",
				"javascript",
				"typescript",
				"tsx",

				"git_rebase",
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
