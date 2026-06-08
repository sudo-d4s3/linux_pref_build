vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.foldlevelstart = 20
vim.opt.showmode = false

vim.filetype.add({
	extension = {
		notes = "markdown",
		tofu = "terraform",
	},
	filename = {
		Containerfile = "dockerfile",
	},
})

vim.g.sonokai_style = "default"
vim.g.sonokai_better_performance = 1
