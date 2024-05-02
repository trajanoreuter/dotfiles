return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    ---@diagnostic disable-next-line: missing-fields
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      textobjects = { enable = true },
      -- enable indentation
      indent = { enable = false },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      sync_install = false,
      auto_install = true,
      -- ensure these language parsers are installed
      ensure_installed = "all",
      ignore_install = { "" },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
