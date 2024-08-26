-- return {
-- 	"folke/tokyonight.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme tokyonight")
-- 	end,
-- }

-- styles:
-- dark
-- darker
-- deep
-- cool
-- warm
-- warmer
return {
   "navarasu/onedark.nvim",
   priority = 1000,

   config = function()
      local scheme = require("onedark");
      scheme.setup({
         style = 'cool'
      })
      scheme.load()
   end
}
