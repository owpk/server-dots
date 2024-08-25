return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({
			fzf_colors = {
				["fg"] = { "fg", "Normal" },
				["bg"] = { "bg", "Normal" },
				["fg+"] = { "fg", "Normal" },
				["bg+"] = { "bg", "Normal" },
			},
			winopts = {
				preview = {
					hidden = "nohidden",
				},
			},
		})
	end,
}
