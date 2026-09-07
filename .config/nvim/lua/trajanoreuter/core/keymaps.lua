-- Keymaps gerais, sem dependência de plugin.
--
-- Onde cada coisa mora:
--   - core/keymaps.lua   -> este arquivo (edição, folds, spell, números)
--   - lsp.lua            -> keymaps de LSP (registrados em LspAttach)
--   - plugins/*.lua      -> keymaps de cada plugin ficam no arquivo do plugin
--   - plugins/which-key  -> nomes dos grupos de <leader> exibidos pelo which-key
--
-- Mapa de prefixos do <leader> (ver plugins/which-key.lua):
--   <leader>c   Code        code action, tagbar
--   <leader>d   Debug/Diag  DAP e diagnostics
--   <leader>e   Explorer    neo-tree
--   <leader>f   Find        telescope
--   <leader>g   Git         hunks, blame e diff (gitsigns)
--   <leader>h   Harpoon     marcar e navegar arquivos
--   <leader>m   Format      conform
--   <leader>n   Swap next   treesitter text-objects
--   <leader>p   Swap prev   treesitter text-objects
--   <leader>r   Refactor    rename, restart LSP
--   <leader>s   Spell       spell check
--   <leader>t   Tabs        tabs, sessões, janelas (<leader>tw) e maximizer
--   <leader>x   Trouble     listas de diagnostics/quickfix
--   <leader>1-9             ir para a tab N

vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------------------------------------------------------------------------
-- Edição
-- ---------------------------------------------------------------------------

-- Manter a seleção depois de indentar
keymap.set("v", "<", "<gv", { desc = "Indent left (keep selection)" })
keymap.set("v", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Mover linhas para cima/baixo
keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })

-- Incrementar/decrementar número sob o cursor
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- ---------------------------------------------------------------------------
-- Folds (abrir/fechar todos: zO / zC em plugins/ufo.lua)
-- ---------------------------------------------------------------------------

keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "Open fold" })
keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "Close fold" })

-- ---------------------------------------------------------------------------
-- Spell
-- ---------------------------------------------------------------------------

keymap.set("n", "<leader>ss", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell check" })
keymap.set("n", "<leader>sc", "z=", { desc = "Spelling suggestions" })

-- ---------------------------------------------------------------------------
-- Code
-- ---------------------------------------------------------------------------

keymap.set("n", "<leader>ct", "<cmd>TagbarToggle<CR>", { desc = "Toggle tagbar" })

-- ---------------------------------------------------------------------------
-- <C-f>/<C-b>: rolar a documentação flutuante do LSP (noice) quando ela está
-- aberta; senão, page down/up suave pelo neoscroll (plugins/scroll.lua).
-- ---------------------------------------------------------------------------

local function scroll(delta, fallback)
  return function()
    local ok, noice_lsp = pcall(require, "noice.lsp")
    if ok and noice_lsp.scroll(delta) then
      return
    end

    local has_neoscroll, neoscroll = pcall(require, "neoscroll")
    if has_neoscroll and vim.fn.mode() == "n" then
      neoscroll[delta > 0 and "ctrl_f" or "ctrl_b"]({ duration = 450 })
      return
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(fallback, true, false, true), "n", false)
  end
end

keymap.set({ "n", "i", "s" }, "<C-f>", scroll(4, "<C-f>"), { silent = true, desc = "Scroll LSP docs / page down" })
keymap.set({ "n", "i", "s" }, "<C-b>", scroll(-4, "<C-b>"), { silent = true, desc = "Scroll LSP docs / page up" })
