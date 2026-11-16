return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Load at startup so `nvim <dir>` opens the tree in place of netrw
  lazy = false,
  opts = {
    renderer = {
      -- Collapse single-child directory chains into one node (src/main/kotlin/com/foo)
      group_empty = true,
    },
    update_focused_file = {
      enable = true,
    },
    actions = {
      open_file = {
        -- Close the tree after opening a file; reopen with <leader>e
        quit_on_open = true,
      },
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle file tree" },
    {
      "<leader>E",
      function()
        local api = require("nvim-tree.api")
        -- open() only focuses an already-open sidebar, so close it first
        api.tree.close()
        api.tree.open({ current_window = true, find_file = true })
      end,
      desc = "Open file tree in current window",
    },
    { "<leader>]", function() require("nvim-tree.api").tree.resize({ relative = 10 }) end, desc = "Widen file tree" },
    { "<leader>[", function() require("nvim-tree.api").tree.resize({ relative = -10 }) end, desc = "Narrow file tree" },
  },
}
