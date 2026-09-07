return {
  "karb94/neoscroll.nvim",
  config = function()
    -- <C-f>/<C-b> ficam de fora: core/keymaps.lua usa eles para rolar a doc
    -- do LSP (noice) e cai no neoscroll quando não há popup aberto.
    require("neoscroll").setup({
      mappings = { "<C-u>", "<C-d>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    })
  end,
}
