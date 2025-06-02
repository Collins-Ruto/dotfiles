require("telescope").setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.5,
        results_width = 0.8,
      },
      vertical = {
        width = 0.9,
        height = 0.95,
        preview_height = 0.5,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    preview = {
      -- optionally configure preview behavior here
      -- hide_on_startup = true,
    },
    winblend = 0,
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  },
  pickers = {
    find_files = {
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        preview_width = 0.5,
        -- width = 0.7,
      },
      sorting_strategy = "ascending",
      path_display = { "smart" },
    },
    buffers = {
      previewer = false,
      theme = "dropdown",
      initial_mode = "normal",
    },
    help_tags = { theme = "ivy" },
    symbols = { theme = "dropdown" },
    registers = { theme = "ivy" },
    grep_string = { initial_mode = "normal", theme = "ivy" },
    live_grep = { theme = "ivy" },
  },
  extensions = {
    undo = {
      side_by_side = true,
      theme = "ivy",
      layout_config = {
        preview_width = 0.7,
      },
    },
    file_browser = {
      theme = "dropdown",
      previewer = false,
    },
  },
}
