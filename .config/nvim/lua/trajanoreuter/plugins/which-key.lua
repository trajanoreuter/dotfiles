return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Nomes dos grupos de prefixo. Os keymaps em si ficam em core/keymaps.lua,
    -- lsp.lua ou no arquivo do plugin que os fornece.
    spec = {
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug / Diagnostics" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>m", group = "Format" },
      { "<leader>n", group = "Swap with next" },
      { "<leader>p", group = "Swap with previous" },
      { "<leader>r", group = "Refactor / LSP" },
      { "<leader>s", group = "Spell" },
      { "<leader>t", group = "Tabs & Sessions" },
      { "<leader>tw", group = "Windows" },
      { "<leader>x", group = "Trouble" },
      { "[", group = "Previous" },
      { "]", group = "Next" },
      { "z", group = "Folds" },
    },
  },
  keys = {
    { "<leader>w", "<cmd>w!<CR>", desc = "Save file" },
    { "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps",
    },
  },
}
