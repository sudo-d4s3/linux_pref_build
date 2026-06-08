return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        python = { "black" },
        rust = { "rustfmt" },
        go = { "gofmt" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
