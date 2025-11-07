return {
  {
    "rmagatti/auto-session",
    config = function()
      local auto_session = require("auto-session")

      auto_session.setup({
        auto_restore_enabled = false,
        auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      })

      local wk = require("which-key")
      wk.add({
        { "<leader>tr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd"},
        { "<leader>ts", "<cmd>SessionSave<CR>", desc = "Save session for cwd"},
        { "<leader>twv", "<C-w>v", desc = "Split window vertically"},
        { "<leader>twh", "<C-w>s",  desc = "Split window horizontally"},
        { "<leader>two", "<C-w>o",  desc = "Close all windows except current"},
        { "<leader>twx", "<cmd>close<CR>",  desc = "Close current split window"},
        { "<leader>twq", "<cmd>q<CR>",  desc = "Close current window"},
        { "<leader>twe", "<C-w>=",  desc = "Equalize window sizes"},
        { "<leader>to", "<cmd>tabnew<CR>",  desc = "Open new tab"},
        { "<leader>tx", "<cmd>tabclose<CR>",  desc = "Close current tab"},
        { "<leader>tn", "<cmd>tabn<CR>",  desc = "Next tab"},
        { "<leader>tp",  "<cmd>tabp<CR>",  desc = "Previous tab"},
        { "<leader>tf", "<cmd>tabnew %<CR>",  desc = "Open current buffer in new tab"},
      })

      local keymap = vim.keymap
      -- naviate between tabs by number
      for i = 1, 9 do
        keymap.set("n", "<leader>" .. i, "<cmd>tabnext " .. i .. "<CR>", { desc = "Switch to tab " .. i })
      end
    end,
  },
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>tm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
}
