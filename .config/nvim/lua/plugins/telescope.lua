return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      {
        "<leader>sf",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Telescope files",
      },
      {
        "<leader>sg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Telescope live_grep",
      },
      {
        "<leader>sb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Telescope buffers",
      },
      {
        "<leader>dF",
        function()
          require("telescope").extensions.dap.frames()
        end,
        desc = "Telescope DAP frames",
      },
      {
        "<leader>dC",
        function()
          require("telescope").extensions.dap.commands()
        end,
        desc = "Telescope DAP commands",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "dap")
    end,
  },
}
