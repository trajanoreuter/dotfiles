return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  config = function()
    local trouble = require("trouble")
    trouble.setup()

    local wk = require("which-key")

    wk.add({
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open/close trouble diagnostics" },
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Open trouble workspace diagnostics",
      },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Open trouble document diagnostics",
      },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    })
  end,
}
