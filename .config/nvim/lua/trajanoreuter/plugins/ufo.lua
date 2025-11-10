return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    local ufo = require("ufo")

    local keymap = vim.keymap
    keymap.set("n", "zO", ufo.openAllFolds, { desc = "Open all folds" })
    keymap.set("n", "zC", ufo.closeAllFolds, { desc = "Close all folds" })

    ufo.setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end,
}
