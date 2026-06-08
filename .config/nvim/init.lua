vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--vim.api.nvim_create_autocmd("User", {
--  pattern = "LazyDone",
--  once = true,
--  callback = function()
--    require("config.lsp_enable")
--    require("config.diagnostics")
--    require("config.keymaps")
--  end,
--})

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "habamax" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    if not vim.api.nvim_get_option_value("modifiable", { buf = args.buf }) then
      return
    end
    if vim.api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "" then
      return
    end
    local ok_conform = pcall(require, "conform")
    if not ok_conform then
      return
    end
    require("conform").format({
      bufnr = args.buf,
      timeout_ms = 5000,
      lsp_fallback = true,
      async = false,
    })
  end,
})

require("config.lsp_enable")
require("config.diagnostics")
require("config.keymaps")
