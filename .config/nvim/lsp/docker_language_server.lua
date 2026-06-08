return {
	cmd = { "docker-language-server", "start", "--stdio" },
	filetypes = { "dockerfile", "yaml.docker-compose" },
	root_markers = {
		"Dockerfile",
		"Containerfile",
		"docker-compose.yaml",
		"docker-compose.yml",
		"compose.yaml",
		"compose.yml",
		"docker-bake.json",
		"docker-bake.hcl",
		".git",
	},
	init_options = {
		telemetry = "off",
	},
	get_language_id = function(_, ftype)
		if ftype == "yaml.docker-compose" or ftype:lower():find("ya?ml") then
			return "dockercompose"
		end
		return ftype
	end,
}
