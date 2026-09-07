return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Keymaps sob <leader>g (grupo Git no which-key).
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navegação
      map("n", "]h", gs.next_hunk, "Next git hunk")
      map("n", "[h", gs.prev_hunk, "Previous git hunk")

      -- Hunk
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected lines")
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected lines")
      map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")

      -- Buffer
      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

      -- Blame e diff
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("n", "<leader>gd", gs.diffthis, "Diff against index")
      map("n", "<leader>gD", function()
        gs.diffthis("~")
      end, "Diff against last commit")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select git hunk")
    end,
  },
}
