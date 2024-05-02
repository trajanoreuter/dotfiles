return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    local keymap = vim.keymap

    keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Add" })

    -- select harpoon 1-9
    for i = 1, 9 do
      keymap.set("n", "<leader>h" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Select " .. i })
    end

    -- Toggle previous & next buffers stored within Harpoon list
    keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end)

    keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end)

    keymap.set("n", "<leader>hl", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Open harpoon window" })
  end,
}
