-- Not compatible mode (though it's unnecessary in Neovim)
vim.opt.compatible = false

-- Enable autoindent
vim.opt.autoindent = true

-- Incremental search
vim.opt.incsearch = true

-- Tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Wrapping and display options
vim.opt.wrap = true
vim.opt.ruler = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.errorbells = false
vim.opt.mouse = "a"
vim.opt.title = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10

-- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- Backspace behavior
vim.opt.backspace = { "indent", "eol", "start" }

-- Command history
vim.opt.history = 1000

-- Allow hidden buffers
vim.opt.hidden = true
