vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
--local wk = require("which-key")

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number under cursor" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor" })

-- Lsp Hover Doc Scrolling
keymap.set({ "n", "i", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true })

keymap.set({ "n", "i", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true })

-- Enable visual mode to preserve selection after indenting
keymap.set("v", "<", "<gv", { noremap = true, silent = true })
keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Tagbar
keymap.set("n", "<leader>ct", ":TagbarToggle<CR>", { desc = "Toggle Tagbar" })

-- folding
keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "Close fold" })
keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "Open fold" })

-- moving code up and down
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
