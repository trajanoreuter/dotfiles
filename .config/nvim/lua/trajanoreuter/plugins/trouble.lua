return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  config = function()
    local trouble = require("trouble")
    trouble.setup()

    local wk = require("which-key")

    wk.add({
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODO comments" },
    })
  end,
}
