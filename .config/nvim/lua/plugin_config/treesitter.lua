require'nvim-treesitter.configs'.setup{
	ensure_installed = {
		'c', 
		'lua', 
		'vim', 
		'vimdoc', 
		'markdown', 
		'markdown_inline', 
		'python', 
		'go', 
		'rust' 
	},
	sync_installed = true,
	auto_install = true,
	highlight = {enable = true, additional_vim_regex_highlighting = false}
}
