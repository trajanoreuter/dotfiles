return {
  "nvim-telescope/telescope.nvim",
  -- branch master: o 0.1.x (2024) quebra o preview com o nvim-treesitter main (ft_to_lang)
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      defaults = {
        -- path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules/" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<CR>"] = actions.select_tab,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    local wk = require("which-key")
    wk.add({
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Grep in project" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODO comments" },
    })
  end,
}
