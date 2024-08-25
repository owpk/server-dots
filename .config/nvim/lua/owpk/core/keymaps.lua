vim.g.mapleader = " "

-- also can use vim.keymap
-- local sk = vim.api.nvim_set_keymap
local sk = vim.keymap

sk.set("i", "jj", "<ESC>", { desc = "Exit insert mode" })
sk.set("n", ",<space>", ":nohlsearch<CR>", { desc = "Clear search highlights", noremap = true, silent = true })
sk.set(
	"n",
	"<C-n>",
	'g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : bufexists(expand(\'%\')) ? ":NERDTreeFind<CR>" : ":NERDTree<CR>"',
	{ noremap = true, silent = true, expr = true }
)
vim.api.nvim_set_var("NERDTreeShowHidden", "1")

sk.set("", "<C-j>", "5j", { noremap = true, silent = true })
sk.set("", "<C-k>", "5k", { noremap = true, silent = true })

--fzf
sk.set("n", ",t", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })

sk.set("n", "'", "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_var("fzf_preview_window", "right:50%:bottom")

-- increment/decrement numbers
sk.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
sk.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- windows management
sk.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
sk.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizonta
sk.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal |
sk.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split |

-- tabs
sk.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
sk.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
sk.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "to next tab" }) -- go to next tab
sk.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "to previous tab" }) -- go to previous tab
sk.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
