-- Modified by cmp.lua
vim.lsp.enable('jedi_language_server')
vim.lsp.enable('gopls')
vim.lsp.enable('marksman')
vim.lsp.config('marksman',{
	filetypes = {"markdown","markdown.mdx","notes"}
})
vim.lsp.enable('yamlls')
vim.lsp.config('yamlls',{
	settings = {
		redhat = {
			telemetry = {
				enabled = false
			}
		},
		yaml = {
			format = {
				enable = true
			}
		}
	}
})
