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
    end, { remap = true })
    keymap.set("", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })
    keymap.set("", "t", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })
    keymap.set("", "T", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
    end, { remap = true })
  end,
}
