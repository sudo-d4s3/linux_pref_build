return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "fzf files",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep_native()
        end,
        desc = "fzf live_grep",
      },
      {
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
        desc = "fzf helptags",
      },
    },
    opts = {},
  },
}
