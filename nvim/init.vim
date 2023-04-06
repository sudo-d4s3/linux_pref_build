"Plugins need to be first
call plug#begin()
Plug 'alaviss/nim.nvim'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sainnhe/sonokai'
call plug#end()

"Set the numbers on the side and fold level
set nu
set rnu
set foldlevelstart=20

"Default settings for sonokai
if has ('termguicolors')
	set termguicolors
endif

let g:sonokay_style = "default"
let g:sonokai_better_performance = 1
colorscheme sonokai
