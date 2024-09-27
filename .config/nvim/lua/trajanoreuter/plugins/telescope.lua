return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
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
    telescope.load_extension("notify")

    -- set keymaps
    local wk = require("which-key")
    wk.register({
      ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Fuzzy find files in cwd" },
      ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Fuzzy find recent files" },
      ["<leader>fs"] = { "<cmd>Telescope live_grep<cr>", "Find string in cwd" },
      ["<leader>fc"] = { "<cmd>Telescope grep_string<cr>", "Find string under cursor in cwd" },
      ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "Find todos" },
    })
  end,
}
