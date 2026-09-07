return {
  "smoka7/hop.nvim",
  version = "*",
  config = function()
    local hop = require("hop")
    hop.setup({
      keys = "etovxqpdygfblzhckisuran",
    })

    local directions = require("hop.hint").HintDirection
    local keymap = vim.keymap
    keymap.set("", "f", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true, desc = "Hop to char forward (line)" })
    keymap.set("", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true, desc = "Hop to char backward (line)" })
    keymap.set("", "t", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
    end, { remap = true, desc = "Hop before char forward" })
    keymap.set("", "T", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
    end, { remap = true, desc = "Hop after char backward" })
  end,
}
