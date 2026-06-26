local o = vim.opt

-- appearance
o.termguicolors  = true
o.background     = "dark"
o.cursorline     = true
o.number         = true
o.relativenumber = true
o.signcolumn     = "yes"
o.scrolloff      = 8
o.sidescrolloff  = 8

-- behavior
o.expandtab      = true
o.shiftwidth     = 4
o.tabstop        = 4
o.smartindent    = true
o.wrap           = false
o.ignorecase     = true
o.smartcase      = true
o.splitbelow     = true
o.splitright     = true
o.updatetime     = 100
o.timeoutlen     = 300
o.undofile       = true
o.swapfile       = false

-- clipboard
o.clipboard      = "unnamedplus"

-- mouse
vim.opt.mouse = "a"
