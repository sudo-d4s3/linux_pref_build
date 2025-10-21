-- Modified by cmp.lua
vim.lsp.enable('jedi_language_server')
vim.lsp.enable('gopls')
vim.lsp.enable('marksman')
vim.lsp.config('marksman',{
	filetypes = {"markdown","markdown.mdx","notes"}
})
