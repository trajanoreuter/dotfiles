vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
--local wk = require("which-key")

local function scroll_lsp_docs(delta, fallback)
  local ok, noice_lsp = pcall(require, "noice.lsp")
  if ok and noice_lsp.scroll(delta) then
    return ""
  end

  return fallback
end

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number under cursor" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor" })

-- Lsp Hover Doc Scrolling
keymap.set({ "n", "i", "s" }, "<c-f>", function()
  return scroll_lsp_docs(4, "<c-f>")
end, { silent = true, expr = true })

keymap.set({ "n", "i", "s" }, "<c-b>", function()
  return scroll_lsp_docs(-4, "<c-b>")
end, { silent = true, expr = true })

-- Enable visual mode to preserve selection after indenting
keymap.set("v", "<", "<gv", { noremap = true, silent = true })
keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Tagbar
keymap.set("n", "<leader>ct", ":TagbarToggle<CR>", { desc = "Toggle Tagbar" })

-- spelling
keymap.set("n", "<leader>ss", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell check" })
keymap.set("n", "<leader>sc", "z=", { desc = "Correct spelling" })

-- folding
keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "Close fold" })
keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "Open fold" })

-- moving code up and down
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
