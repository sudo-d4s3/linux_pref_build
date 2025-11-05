local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
-- Theme
Plug('sainnhe/sonokai')

-- lsp + snippets + autocomplete
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})
Plug('neovim/nvim-lspconfig')
Plug('L3MON4D3/LuaSnip', {['tag'] = 'v2.*', ['do'] = 'make install_jsregexp'})
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/nvim-cmp')
Plug('saadparwaiz1/cmp_luasnip')
Plug('rafamadriz/friendly-snippets')

-- fuzzy finder
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

-- powerline alt
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-tree/nvim-web-devicons')

-- Render Markdown in neovim
-- Plug('MeanderingProgrammer/render-markdown.nvim')

-- obisian vault for neovim
-- Plug('epwalsh/obsidian.nvim')

-- python stuffz
Plug('pappasam/jedi-language-server') -- language server
Plug('psf/black', {branch = 'stable'}) -- linter

-- bunch 'o go helpers: linter, auto import, language server, etc
Plug('ray-x/go.nvim')

-- yaml stuffz
-- Plug('someone-stole-my-name/yaml-companion.nvim')

vim.call('plug#end')


vim.filetype.add({
  extension = {notes = 'markdown'},
  extension = {tofu = 'terraform'}
})

require('plugin_config')


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldlevelstart = 20
vim.opt.showmode = false -- lualine shows this already
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.confirm = true

vim.opt.conceallevel = 1 -- for obsidian.nvim

vim.cmd("let g:sonokai_style = 'default'")
vim.cmd("let g:sonokai_better_performance = 1")
vim.cmd.colorscheme("sonokai")
