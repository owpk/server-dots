return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },

	-- syntax: "edit operator (y,d...)" + s + "bounds (i - work, etc)" + "surround type (char, tag, etc)"
	-- ysiw - surround with char
	-- ds - delete surrounding
	-- cs - change surrounding
	config = function()
		local substitute = require("substitute")
		substitute.setup()

		local km = vim.keymap
		km.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
		km.set("n", "ss", substitute.line, { desc = "Substitute line" })
		km.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
		km.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
	end,
}
