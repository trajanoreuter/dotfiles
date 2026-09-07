-- Keymaps de LSP, registrados por buffer quando um servidor conecta.
-- Grupos do which-key: <leader>c (Code), <leader>r (Refactor / LSP),
-- <leader>d (Debug / Diagnostics). Ver plugins/which-key.lua.

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end

    -- Navegação
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to implementations")
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to type definitions")
    map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show references")

    -- Documentação
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")

    -- Ações
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP")

    -- Diagnostics
    map("n", "<leader>dd", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics")
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
  end,
})

-- vim.lsp.inlay_hint.enable(true)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
