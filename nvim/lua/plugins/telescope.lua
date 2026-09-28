return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      path_display = { "filename_first" },
    },
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    { "<leader>fv", function() require("telescope.builtin").git_files() end, desc = "Git files" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles({ cwd_only = true }) end, desc = "Recent files (project)" },
    { "<leader>fs", function() require("telescope.builtin").git_status() end, desc = "Git status" },
  },
}
