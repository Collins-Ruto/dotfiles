return {
  -- Required dependencies
  { "MunifTanjim/nui.nvim" },
  { "rcarriga/nvim-notify" },

  -- Main plugin
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lualine/lualine.nvim", -- optional, for statusline integration
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          progress = { enabled = true },
          hover = { enabled = true },
          signature = { enabled = true },

          -- ⛔️ Disable overrides that interfere with default LSP UI
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
        },
        presets = {
          bottom_search = false,
          command_palette = true, -- 👈 makes command window centered!
          long_message_to_split = true,
          lsp_doc_border = true,
        },
        views = {
          cmdline_popup = {
            position = {
              row = "80%",
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          cmdline_popupmenu = {
            relative = "editor",
            position = {
              row = "70%", -- slightly below cmdline
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
            },
          },
        },
      }
    end,
  },
}
