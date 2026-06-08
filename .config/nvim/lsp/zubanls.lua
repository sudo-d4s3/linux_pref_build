return {
	name = "ZubanLS",
	cmd = { "zuban", "server" },
	root_markers = {
		".git",
		"pyproject.toml",
		"setup.cfg",
		"setup.py",
		"requirements.txt",
	},
	filetypes = { "python" },
}
