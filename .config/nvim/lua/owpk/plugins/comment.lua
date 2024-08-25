return {
   "numToStr/Comment.nvim",
   event = { "BufReadPre", "BufNewFile" },

   dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring"
   },

   config = function() 
      local comment = require("Comment")
      local ts_ctx_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      comment.setup({
         opleader = {
            ---Line-comment keymap
            line = '<C-/>',
            ---Block-comment keymap
            block = 'gb',
         },
         pre_hook = ts_ctx_commentstring.create_pre_hook()
      })
   end
   
}
