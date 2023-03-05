local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'

-- Tooling
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kelly-lin/telescope-ag'
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'
Plug 'tpope/vim-repeat'
Plug 'mfussenegger/nvim-dap'
Plug 'mxsdev/nvim-dap-vscode-js'
Plug 'mhinz/vim-startify'
-- Plug 'townk/vim-autoclose'
Plug 'jiangmiao/auto-pairs'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'
Plug 'jeetsukumaran/vim-indentwise'

-- Action Ease
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm'
Plug 'sindrets/diffview.nvim'


-- Syntax / Lsp / Flow
Plug 'hrsh7th/nvim-cmp'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
-- Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

-- Visual Ease
Plug 'anuvyklack/pretty-fold.nvim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
-- Plug 'bluz71/vim-moonfly-colors' , { 'as': 'moonfly' }


Plug 'jacoborus/tender.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'statianzo/vim-jade'
Plug 'airblade/vim-gitgutter'
Plug 'ojroques/nvim-hardline'


-- RANDOM
Plug 'tpope/vim-sensible'

vim.call('plug#end')

require("nvim-tree").setup()
require('pretty-fold').setup()
require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}
require("null-ls").setup()
require("hardline").setup {}
require("noice").setup()
