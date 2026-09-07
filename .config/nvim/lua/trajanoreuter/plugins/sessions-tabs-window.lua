-- Sessões, tabs e janelas. Tudo sob <leader>t; janelas ficam em <leader>tw.
-- O maximizer (<leader>tm) está em plugins/vim-maximizer.lua.
return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local wk = require("which-key")
    wk.add({
      -- Sessões
      { "<leader>ts", "<cmd>SessionSave<CR>", desc = "Save session (cwd)" },
      { "<leader>tr", "<cmd>SessionRestore<CR>", desc = "Restore session (cwd)" },

      -- Tabs
      { "<leader>to", "<cmd>tabnew<CR>", desc = "New tab" },
      { "<leader>tx", "<cmd>tabclose<CR>", desc = "Close tab" },
      { "<leader>tn", "<cmd>tabn<CR>", desc = "Next tab" },
      { "<leader>tp", "<cmd>tabp<CR>", desc = "Previous tab" },
      { "<leader>tf", "<cmd>tabnew %<CR>", desc = "Open buffer in new tab" },

      -- Janelas (splits)
      { "<leader>twv", "<C-w>v", desc = "Split vertically" },
      { "<leader>twh", "<C-w>s", desc = "Split horizontally" },
      { "<leader>twe", "<C-w>=", desc = "Equalize window sizes" },
      { "<leader>two", "<C-w>o", desc = "Close other windows" },
      { "<leader>twx", "<cmd>close<CR>", desc = "Close window" },
      { "<leader>twq", "<cmd>q<CR>", desc = "Quit window" },
    })

    -- Ir direto para a tab N
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, "<cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
    end
  end,
}
