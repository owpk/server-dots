return {
	"rmagatti/auto-session",

	config = function()
		local auto_session = require("auto-session")
		local opts = {
			autp_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },

			--auto_session_enable_last_session = false,
			--auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
			--auto_session_enabled = true,
			--auto_save_enabled = nil,
			--auto_restore_enabled = nil,
			--auto_session_suppress_dirs = {
			--  -- vim.fn.glob(vim.fn.stdpath "config" .. "/*"),
			--  os.getenv "HOME",
			--  -- os.getenv "HOME" .. "/Machfiles",
			--},
			--auto_session_use_git_branch = nil,
			---- the configs below are lua only
			--bypass_session_save_file_types = { "alpha" },
		}

		auto_session.setup(opts)
		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
	end,
}
