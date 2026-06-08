return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      keymap = { 
		preset = "enter",
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      snippets = {
        preset = "luasnip",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },
}
