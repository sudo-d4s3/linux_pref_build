local M = {}

function M.extract()
  local ft = vim.bo.filetype
  if ft == "python" then
    vim.cmd.norm("gv" .. require("refactoring").extract_func())
    return
  end
  if ft ~= "go" and ft ~= "rust" then
    vim.notify("extract: unsupported filetype " .. ft, vim.log.levels.WARN)
    return
  end
  vim.lsp.buf.code_action({
    context = {
      only = {
        "refactor.extract",
        "refactor.extract.function",
        "refactor.rewrite",
      },
    },
  })
end

return M
