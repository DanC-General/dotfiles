-- Use system clipboard
vim.opt.clipboard = "unnamed"
vim.keymap.set({ "n", "x" }, "cp", '"+y')
vim.keymap.set({ "n", "x" }, "cv", '"+p')
-- Delete without changing the registers
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- Set leader key to Space
vim.g.mapleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jj", "<Esc>") -- Exit insert mode with jj
vim.keymap.set("n", "<leader>w", "<C-W>") -- Window commands with leader+w
vim.keymap.set("n", "<leader>b", "<Esc>:split term://bash<CR>")
vim.keymap.set("n", "<leader>e", "<Esc>")
vim.keymap.set("n", "<C-f>", "<leader>f")
vim.keymap.set("n", "<C-e>", "<leader>e")
vim.keymap.set({ "n" }, "<leader>/", "gcc")
vim.keymap.set("v", "<leader>/", "gc")
vim.keymap.set("n", "-", "$")

-- Toggle hls
vim.keymap.set("n", "<leader>h", function()
	vim.o.hlsearch = not vim.o.hlsearch
end, { desc = "Toggle hlsearch" })

-- Tab controls
vim.keymap.set("n", "<leader>th", "<ESC>:tabp<CR>")
vim.keymap.set("n", "<leader>tt", "<ESC>:tabnew<CR>")
vim.keymap.set("n", "<leader>tl", "<ESC>:tabn<CR>")

local operator_rhs = function()
	return require("vim._comment").operator()
end
vim.keymap.set({ "n", "x" }, "<leader>/", operator_rhs, { expr = true, desc = "Toggle comment" })

local line_rhs = function()
	return require("vim._comment").operator() .. "_"
end
vim.keymap.set("n", "<leader>/", line_rhs, { expr = true, desc = "Toggle comment line" })

local textobject_rhs = function()
	require("vim._comment").textobject()
end
vim.keymap.set({ "o" }, "<leader>/", textobject_rhs, { desc = "Comment textobject" })

-- Disable arrow keys in normal mode
vim.keymap.set({ "n", "i" }, "<Up>", "<NOP>", { noremap = true })
vim.keymap.set({ "n", "i" }, "<Down>", "<NOP>", { noremap = true })
vim.keymap.set({ "n", "i" }, "<Left>", "<NOP>", { noremap = true })
vim.keymap.set({ "n", "i" }, "<Right>", "<NOP>", { noremap = true })
vim.keymap.set("t", "jj", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>9", "<C-W>v")
vim.keymap.set("n", "<leader>0", "<C-W>s")

-- Plugin keybinds
vim.keymap.set("n", "<leader>N", "<ESC>:Neotree<CR>")
vim.keymap.set("n", "<leader>o", "<ESC>:Oil<CR>")
