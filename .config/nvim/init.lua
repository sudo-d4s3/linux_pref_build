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

-- language server python
Plug('pappasam/jedi-language-server')

-- linter python
Plug('psf/black', {branch = 'stable'})

-- bunch 'o go helpers: linter, auto import, language server, etc
Plug('ray-x/go.nvim')

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
vim.call('plug#end')


vim.filetype.add({
  extension = {notes = 'markdown'}
})

require('plugin_config')


vim.cmd("set nu")
vim.cmd("set rnu")
vim.cmd("set foldlevelstart=20")

vim.opt.conceallevel = 1 -- for obsidian.nvim

vim.cmd("let g:sonokai_style = 'default'")
vim.cmd("let g:sonokai_better_performance = 1")
vim.cmd.colorscheme("sonokai")
