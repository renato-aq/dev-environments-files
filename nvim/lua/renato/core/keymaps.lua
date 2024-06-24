vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", {desc = "exit insert mode with jk"})

keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "clear search highlights"})

--increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {desc = "increment number"})
keymap.set("n", "<leader>-", "<C-x>", {desc = "decrement number"})

--winddow management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "split window verticaly"}) --split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", {desc = "split window horizontally"}) --split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", {desc = "make split equal size"}) --make split windows equal size
keymap.set("n", "<leader>sx", "<cmd>close<CR>", {desc = "close current split"}) --close current split


--tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {desc = "open new tab"})
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {desc = "close current tab"})
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {desc = "go to next tab"})
keymap.set("n", "<leader>tp", "<cmd>tabnew<CR>", {desc = "go to previuse tab"})
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc = "open current buffer in new tab"})
