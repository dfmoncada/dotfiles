local o = vim.o
local wo = vim.wo
local bo = vim.bo

local HOME = os.getenv("HOME")

require('plugins')

-- plugins configs
-- require('telescopconfig')
-- require('lspconfigconfig')



-- Common ( maybe move it to single file?)
vim.api.nvim_set_var("mapleader", " ")

o.smarttab = true
o.smartcase = true
o.swapfile = false
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12
o.completeopt = "menu,menuone,noselect"
o.list = true
o.listchars = "tab:→ ,nbsp:␣,trail:•,precedes:«,extends:»"
o.mouse='a'

o.undofile = true
o.undodir = HOME .. "/.vim/undo"
o.undolevels = 1000
o.undoreload = 10000

wo.number = false
wo.wrap = false
wo.number = true
wo.relativenumber = true
wo.foldmethod = 'indent'
-- wo.foldmethod = 'expr'
wo.foldexpr = 'nvim_treesitter#foldexpr()'
wo.foldlevel = 99


bo.expandtab = true
bo.tabstop = 2
bo.shiftwidth = 2
bo.autoindent = true



-- source $HOME/.config/nvim/lua/lspconfigconfig.lua
-- source $HOME/.config/nvim/lua/treesitterconfig.lua
vim.api.nvim_command([[
    source $HOME/.config/nvim/lua/telescopconfig.lua
    source $HOME/.config/nvim/lua/cmp_config.lua
    source $HOME/.config/nvim/lua/diff_view.lua
    nnoremap <space><space> <C-^>
    nnoremap   <silent>   <F7>    :FloatermNew<CR>
    tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
    nnoremap   <silent>   <F8>    :FloatermPrev<CR>
    tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
    nnoremap   <silent>   <F9>    :FloatermNext<CR>
    tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
    nnoremap   <silent>   <F12>   :FloatermToggle<CR>
    tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
    colorscheme gruvbox
    set autoindent expandtab tabstop=2 shiftwidth=2
    set colorcolumn=80
]])

require 'treesitterconfig'
require 'lspconfigconfig'
require 'nullls'
require 'prettierconfig'


-- vim.api.nvim_set_keymap("n", "<leader>a", ":Git blame<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>g", ":Telescope git_status<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>G", ":Git<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeFindFileToggle<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":bd<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>Q", ":qa<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>w", ":w<cr>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "-", ":Ex<cr>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-A>", "<Home>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-`>", "<Home>", { noremap = true })




vim.cmd[[
    augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=500})
    augroup END
]]
