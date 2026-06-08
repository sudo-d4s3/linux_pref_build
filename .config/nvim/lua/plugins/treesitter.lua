local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "python",
  "go",
  "rust",
  "toml",
  "markdown",
  "query",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.schedule(function()
        require("nvim-treesitter.configs").setup({
          sync_install = false,
          ensure_installed = parsers,
          auto_install = false,
          highlight = { enable = true },
          incremental_selection = { enable = true },
        })
      end)
    end,
  },
}
