return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    local swap = require("nvim-treesitter-textobjects.swap")
    local move = require("nvim-treesitter-textobjects.move")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    -- configure textobjects
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    -- select keymaps
    local select_keymaps = {
      ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
      ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
      ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
      ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
      ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
      ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
      ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
      ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
      ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
      ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
      ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
      ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
      ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
      ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
      ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
      ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
      ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
      ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
      ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
      ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
    }
    for key, mapping in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(mapping.query)
      end, { desc = mapping.desc })
    end

    -- swap keymaps
    vim.keymap.set("n", "<leader>na", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap parameter with next" })
    vim.keymap.set("n", "<leader>n:", function()
      swap.swap_next("@property.outer")
    end, { desc = "Swap object property with next" })
    vim.keymap.set("n", "<leader>nm", function()
      swap.swap_next("@function.outer")
    end, { desc = "Swap function with next" })
    vim.keymap.set("n", "<leader>pa", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap parameter with prev" })
    vim.keymap.set("n", "<leader>p:", function()
      swap.swap_previous("@property.outer")
    end, { desc = "Swap object property with prev" })
    vim.keymap.set("n", "<leader>pm", function()
      swap.swap_previous("@function.outer")
    end, { desc = "Swap function with previous" })

    -- move keymaps
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@call.outer")
    end, { desc = "Next function call start" })
    vim.keymap.set({ "n", "x", "o" }, "]m", function()
      move.goto_next_start("@function.outer")
    end, { desc = "Next method/function def start" })
    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      move.goto_next_start("@class.outer")
    end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]i", function()
      move.goto_next_start("@conditional.outer")
    end, { desc = "Next conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "]l", function()
      move.goto_next_start("@loop.outer")
    end, { desc = "Next loop start" })
    vim.keymap.set({ "n", "x", "o" }, "]s", function()
      move.goto_next_start("@scope", "locals")
    end, { desc = "Next scope" })
    vim.keymap.set({ "n", "x", "o" }, "]z", function()
      move.goto_next_start("@fold", "folds")
    end, { desc = "Next fold" })
    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      move.goto_next_end("@call.outer")
    end, { desc = "Next function call end" })
    vim.keymap.set({ "n", "x", "o" }, "]M", function()
      move.goto_next_end("@function.outer")
    end, { desc = "Next method/function def end" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function()
      move.goto_next_end("@class.outer")
    end, { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "]I", function()
      move.goto_next_end("@conditional.outer")
    end, { desc = "Next conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "]L", function()
      move.goto_next_end("@loop.outer")
    end, { desc = "Next loop end" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@call.outer")
    end, { desc = "Prev function call start" })
    vim.keymap.set({ "n", "x", "o" }, "[m", function()
      move.goto_previous_start("@function.outer")
    end, { desc = "Prev method/function def start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      move.goto_previous_start("@class.outer")
    end, { desc = "Prev class start" })
    vim.keymap.set({ "n", "x", "o" }, "[i", function()
      move.goto_previous_start("@conditional.outer")
    end, { desc = "Prev conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "[l", function()
      move.goto_previous_start("@loop.outer")
    end, { desc = "Prev loop start" })
    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      move.goto_previous_end("@call.outer")
    end, { desc = "Prev function call end" })
    vim.keymap.set({ "n", "x", "o" }, "[M", function()
      move.goto_previous_end("@function.outer")
    end, { desc = "Prev method/function def end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function()
      move.goto_previous_end("@class.outer")
    end, { desc = "Prev class end" })
    vim.keymap.set({ "n", "x", "o" }, "[I", function()
      move.goto_previous_end("@conditional.outer")
    end, { desc = "Prev conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "[L", function()
      move.goto_previous_end("@loop.outer")
    end, { desc = "Prev loop end" })

    -- repeatable moves: ; goes to the direction you were moving
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
