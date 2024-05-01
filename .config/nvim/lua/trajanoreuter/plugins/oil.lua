return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup()

    local keymap = vim.keymap
    keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open oil" })
  end,
}
