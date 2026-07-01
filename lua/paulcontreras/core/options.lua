vim.cmd("let g:netrw_liststyle = 3")

-- Disable unused language providers to keep :checkhealth focused on tools this
-- config actually uses.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearance
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8 -- keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- keep 8 cols left/right of cursor
opt.pumheight = 12 -- max completion popup height
opt.colorcolumn = "120" -- visual line-length guide

-- Editing
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.iskeyword:append("-") -- treat dash-separated words as one word

-- Splits
opt.splitright = true
opt.splitbelow = true

-- File handling
opt.swapfile = false
opt.undofile = true -- persistent undo (survives restarts)
opt.fileencoding = "utf-8"
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Performance / responsiveness
opt.updatetime = 250 -- faster CursorHold → faster gitsigns, hover, etc.
opt.timeoutlen = 300 -- which-key popup delay

-- Mouse
opt.mouse = "a"

-- Concealment (show raw chars in markdown etc.)
opt.conceallevel = 0

-- Project-local config files (.nvim.lua / .exrc)
opt.exrc = true
