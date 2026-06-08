local function pick_rust_binary()
  local cwd = vim.fn.getcwd()
  local globs = vim.fn.glob(vim.fs.joinpath(cwd, "target", "debug", "*"), false, true)
  for _, p in ipairs(globs) do
    if vim.fn.executable(p) == 1 and vim.fn.isdirectory(p) == 0 then
      return p
    end
  end
  local guess = vim.fs.joinpath(cwd, "target", "debug", vim.fn.fnamemodify(cwd, ":t"))
  if vim.fn.executable(guess) == 1 then
    return guess
  end
  return vim.fn.input("Rust debug binary: ", vim.fs.joinpath(cwd, "target", "debug", ""), "file")
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP step out",
      },
      {
        "<leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
            if condition and condition ~= "" then
              require("dap").set_breakpoint(condition)
            end
          end)
        end,
        desc = "DAP conditional breakpoint",
      },
    },
    config = function()
      local dap = require("dap")
      local mason_cmd = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
      local cmd = vim.fn.executable(mason_cmd) == 1 and mason_cmd or "codelldb"
      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = cmd,
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Rust (CodeLLDB) launch",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = pick_rust_binary,
          stopOnEntry = false,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI toggle",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "DAP repl",
      },
    },
    config = function()
      require("dapui").setup({})
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      local mason_py = vim.fn.expand(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
      if vim.fn.executable(mason_py) == 1 then
        require("dap-python").setup(mason_py)
      else
        require("dap-python").setup()
      end
    end,
  },
  {
    "leoluz/nvim-dap-go",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      require("dap-go").setup()
    end,
  },
}
