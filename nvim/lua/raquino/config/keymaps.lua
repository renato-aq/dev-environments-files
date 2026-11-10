local map = vim.keymap.set

-- Registers
map("n", "x", '"_x')
map({ "n", "v" }, "<leader>d", '"_d')
map({ "n", "v" }, "<leader>c", '"_c')
map({ "n", "v" }, "<leader>p", '"0p')
map("n", "dw", 'vb"_d')

-- Search
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear the search highlight" })

-- Numbers and selection
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")
map("n", "<C-a>", "gg<S-v>G")

-- Tabs
map("n", "te", "<cmd>tabedit<cr>")
map("n", "tq", "<cmd>tabclose<cr>")
map("n", "<Tab>", "<cmd>tabnext<cr>")
map("n", "<S-Tab>", "<cmd>tabprevious<cr>")

-- Windows
map("n", "ss", "<cmd>split<cr>")
map("n", "sv", "<cmd>vsplit<cr>")
map("n", "sh", "<C-w>h")
map("n", "sj", "<C-w>j")
map("n", "sk", "<C-w>k")
map("n", "sl", "<C-w>l")

-- <C-i> is the same key as Tab in the terminal
map("n", "<C-m>", "<C-i>")

-- New lines without continuing a comment
map("n", "<leader>o", "o<Esc>^Da")
map("n", "<leader>O", "O<Esc>^Da")

-- Buffers
map("n", "<leader>bd", function()
	Raquino.editor.close_hidden_buffers()
end, { desc = "Close hidden buffers" })

-- Agent helpers
map("n", "<leader>yf", function()
	Raquino.editor.copy_path()
end, { desc = "Copy relative path with line" })
map("n", "<leader>yp", function()
	Raquino.editor.copy_path({ absolute = true })
end, { desc = "Copy absolute path with line" })
map("v", "<leader>cc", function()
	Raquino.editor.copy_code_block()
end, { desc = "Copy selection as code block" })
map("n", "<leader>j", function()
	Raquino.editor.open_package_json()
end, { desc = "Open package.json" })
