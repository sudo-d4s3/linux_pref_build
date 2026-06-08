vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = {
    border = "rounded",
  },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for sev, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. sev
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
