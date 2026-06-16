return {
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "neovim-treesitter/nvim-treesitter", "lewis6991/async.nvim" },
    config = true,
  },
}
