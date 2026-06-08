vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set(
  "x",
  "<leader>rf",
  "<Cmd>lua require('config.refactor').extract()<CR>",
  { silent = true, desc = "Extract selection into function (LSP / refactoring.nvim)" }
)

