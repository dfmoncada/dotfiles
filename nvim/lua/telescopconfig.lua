-- Using Lua functions
vim.api.nvim_set_keymap('n', '<leader>p', ":Telescope git_files<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>f', ":Telescope live_grep<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>F', ":Telescope grep_string<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>b', ":Telescope buffers<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>m', ":Telescope oldfiles<cr>", { noremap = true })
