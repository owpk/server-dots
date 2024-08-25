return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},

			renderer = {
				indent_markers = {
					enable = true,
				},

				icons = {
					glyphs = {
						folder = {
							arrow_closed = "⏵",
							arrow_open = "⏷",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "⌥",
							renamed = "➜",
							untracked = "★",
							deleted = "⊖",
							ignored = "◌",
						},
					},
				},
			},

			filters = {
				custom = { ".DS_Store" },
			},

			-- open_file = {
			-- 	window_picker = {
			-- 		enable = false,
			-- 	},
			-- },

			git = {
				ignore = false,
			},
		})

		local km = vim.keymap
		km.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		km.set("n", "<C-n>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer" })
		km.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		km.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
