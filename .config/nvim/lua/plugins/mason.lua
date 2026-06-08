return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    priority = 10000,
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
      local sep = vim.fn.has("win32") == 1 and ";" or ":"
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      vim.env.PATH = mason_bin .. sep .. vim.env.PATH
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "zuban",
          "gopls",
          "rust-analyzer",
          "debugpy",
          "delve",
          "codelldb",
          "black",
          "golangci-lint",
	  "terraform-ls",
	  "tree-sitter-cli",
	  "docker-language-server",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
}
