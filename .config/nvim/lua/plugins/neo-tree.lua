return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "muniftanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.fn.getcwd(),
          })
        end,
        desc = "Neo-tree toggle",
      },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
}
