local parsers = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "gitignore",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "prisma",
  "query",
  "svelte",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = function()
    require("nvim-treesitter").update(parsers, { summary = true })
  end,
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()

    local installed = {}
    for _, parser in ipairs(treesitter.get_installed()) do
      installed[parser] = true
    end

    local missing = {}
    for _, parser in ipairs(parsers) do
      if not installed[parser] then
        table.insert(missing, parser)
      end
    end

    if #missing > 0 then
      treesitter.install(missing, { summary = true })
    end

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("trajanoreuter_treesitter", { clear = true }),
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
