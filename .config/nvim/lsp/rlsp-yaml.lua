return {
	cmd = { "rlsp-yaml" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	init_options = {
		schemaStore = true,
		schemas = {
			["./schemas/sigma-custom-schema.json"] = "detections/*.yml",
			["./schemas/sigma-detection-rule-schema.json"] = "detections/*.yml"
		},
	},
}
