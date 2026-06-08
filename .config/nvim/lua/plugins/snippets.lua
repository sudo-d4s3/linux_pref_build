return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    build = (function()
      if vim.fn.executable("make") == 1 then
        return "make install_jsregexp"
      end
    end)(),
    config = function()
      local vscode = require("luasnip.loaders.from_vscode")

      local ok, err = pcall(vscode.lazy_load)
      if not ok then
        vim.notify("LuaSnip friendly-snippets: " .. tostring(err), vim.log.levels.WARN)
      end

      ok, err = pcall(vscode.lazy_load, { paths = { vim.fn.stdpath("config") .. "/snippets" } })
      if not ok then
        vim.notify("LuaSnip custom snippets: " .. tostring(err), vim.log.levels.WARN)
      end
    end,
  },
}
