-- Navegação transparente entre splits do neovim e panes do herdr.
--
-- Contraparte do ~/.config/herdr/scripts/navigator.sh: o herdr captura
-- <C-h/j/k/l>, vê que o pane roda nvim e repassa a tecla para cá. Aqui o
-- movimento acontece dentro do neovim e, quando já estamos na borda do layout,
-- devolvemos o movimento ao herdr. Mesmo comportamento que o
-- christoomey/vim-tmux-navigator dava sob o tmux, que segue valendo fora do
-- herdr.
--
-- Docs: https://herdr.dev/docs/cli-reference/#panes

local pane_id = vim.env.HERDR_PANE_ID

if vim.env.HERDR_ENV ~= "1" or not pane_id or pane_id == "" then
  return
end

local herdr = vim.env.HERDR_BIN_PATH
if not herdr or herdr == "" then
  herdr = "herdr"
end

local directions = {
  h = "left",
  j = "down",
  k = "up",
  l = "right",
}

local function navigate(key)
  return function()
    local from = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)

    -- A janela não mudou: estamos na borda do layout, então o movimento é do herdr.
    if from == vim.api.nvim_get_current_win() then
      vim.system({ herdr, "pane", "focus", "--pane", pane_id, "--direction", directions[key] })
    end
  end
end

-- O vim-tmux-navigator é carregado pelo lazy.nvim depois deste módulo, então
-- registramos os mapeamentos em VimEnter para que estes vençam dentro do herdr.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("HerdrNavigator", { clear = true }),
  callback = function()
    for key, direction in pairs(directions) do
      vim.keymap.set("n", "<C-" .. key .. ">", navigate(key), {
        silent = true,
        desc = "Navigate " .. direction .. " (nvim split or herdr pane)",
      })
    end
  end,
})
