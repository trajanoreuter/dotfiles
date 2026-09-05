-- Omarchy: segue o tema do sistema quando rodando no Omarchy (Arch + Hyprland).
--
-- `omarchy theme set` escreve ~/.local/state/omarchy/current/theme/neovim.lua,
-- um spec do lazy.nvim no formato do LazyVim: o plugin do colorscheme mais um
-- item "LazyVim/LazyVim" cujo opts.colorscheme diz qual scheme ativar. Aqui a
-- gente extrai as duas coisas: o plugin entra no lazy e o nome vai para
-- vim.g.omarchy_colorscheme, que plugins/colorscheme.lua usa no lugar do
-- catppuccin. Fora do Omarchy (macOS, Ubuntu) o arquivo não existe e este
-- módulo não faz nada.
--
-- Troca de tema em runtime não recarrega: reabra o nvim.

local theme_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(theme_file) == 0 then
  return {}
end

local ok, specs = pcall(dofile, theme_file)
if not ok or type(specs) ~= "table" then
  return {}
end

local plugins = {}
for _, spec in ipairs(specs) do
  if spec[1] == "LazyVim/LazyVim" then
    vim.g.omarchy_colorscheme = spec.opts and spec.opts.colorscheme
  elseif spec[1] then
    spec.lazy = false
    spec.priority = spec.priority or 1000
    table.insert(plugins, spec)
  end
end

if not vim.g.omarchy_colorscheme then
  return {}
end

-- O terminal do Omarchy é translúcido (ghostty background-opacity); deixa o
-- fundo do nvim transparente como o catppuccin já faz com transparent_background.
local transparent_groups = {
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "EndOfBuffer",
  "SignColumn", "LineNr", "CursorLineNr", "FoldColumn", "Folded",
  "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
  "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder", "TelescopePromptTitle",
  "WhichKeyFloat",
}

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("OmarchyTransparency", { clear = true }),
  pattern = vim.g.omarchy_colorscheme,
  callback = function()
    for _, name in ipairs(transparent_groups) do
      local found, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if found then
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end,
})

return plugins
