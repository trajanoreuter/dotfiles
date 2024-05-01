return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local illuminate = require("illuminate")

    local opts = {
      delay = 100,
      filetypes_denylist = {
        "mason",
        "harpoon",
        "neo-tree",
        "DressingInput",
        "NeogitCommitMessage",
        "qf",
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "Trouble",
        "netrw",
        "lir",
        "DiffviewFiles",
        "Outline",
        "Jaq",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },
    }

    illuminate.configure(opts)
  end,
}
