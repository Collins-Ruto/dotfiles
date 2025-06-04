return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        matcher = {
          frecency = true,
        },
        layout = {
          preset = "ivy",
          cycle = false,
        },
        layouts = {
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.5,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
            },
          },
          vertical = {
            layout = {
              backdrop = false,
              width = 0.8,
              height = 0.8,
              min_width = 80,
              min_height = 30,
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", height = 0.4, border = "top" },
            },
          },
          telescope = {
            reverse = true,
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.55,
                border = "rounded",
                title_pos = "center",
              },
            },
          },
        },
        transform = function(item)
          if item.file and item.file:match "lazyvim/lua/config/keymaps%.lua" then
            item.score_add = (item.score_add or 0) - 30
          end
          return item
        end,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["J"] = { "preview_scroll_down", mode = { "n", "i" } },
              ["K"] = { "preview_scroll_up", mode = { "n", "i" } },
              ["H"] = { "preview_scroll_left", mode = { "n", "i" } },
              ["L"] = { "preview_scroll_right", mode = { "n", "i" } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
      },
      lazygit = {
        theme = {
          selectedLineBgColor = { bg = "CursorLine" },
        },
        win = {
          width = 0,
          height = 0,
        },
      },
      image = {
        enabled = true,
        doc = {
          inline = vim.g.neovim_mode == "skitty",
          float = true,
          max_width = vim.g.neovim_mode == "skitty" and 5 or 60,
          max_height = vim.g.neovim_mode == "skitty" and 2.5 or 30,
        },
      },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      notifier = { enabled = false },
    },
    keys = {
      {
        "<leader><space>",
        function()
          require("snacks").picker.files {
            finder = "files",
            format = "file",
            show_empty = true,
            supports_live = true,
          }
        end,
        desc = "Find Files (Snacks)",
      },
      {
        "<leader>gl",
        function()
          require("snacks").picker.git_log {
            finder = "git_log",
            format = "git_log",
            preview = "git_show",
            confirm = "git_checkout",
            layout = "vertical",
          }
        end,
        desc = "Git Log (vertical)",
      },
      {
        "<S-h>",
        function()
          require("snacks").picker.buffers {
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = { keys = { ["d"] = "bufdelete" } },
              list = { keys = { ["d"] = "bufdelete" } },
            },
          }
        end,
        desc = "Buffers (Snacks)",
      },
      {
        "<M-b>",
        function()
          require("snacks").picker.git_branches { layout = "select" }
        end,
        desc = "Git Branches",
      },
      {
        "<C-k>",
        function()
          require("snacks").picker.keymaps { layout = "vertical" }
        end,
        desc = "Search Keymaps",
      },
      {
        "<leader>tt",
        function()
          require("snacks").picker.grep {
            prompt = " ",
            search = "^\\s*- \\[ \\]",
            regex = true,
            live = false,
            dirs = { vim.fn.getcwd() },
            args = { "--no-ignore" },
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            layout = "telescope",
          }
        end,
        desc = "TODO Tasks (unchecked)",
      },
      {
        "<leader>tc",
        function()
          require("snacks").picker.grep {
            prompt = " ",
            search = "^\\s*- \\[x\\] `done:",
            regex = true,
            live = false,
            dirs = { vim.fn.getcwd() },
            args = { "--no-ignore" },
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            layout = "ivy",
          }
        end,
        desc = "TODO Tasks (done)",
      },
      {
        "<leader>fb",
        function()
          require("snacks").picker.buffers()
        end,
        desc = "Buffers (Snacks)",
      },
      {
        "<leader>fg",
        function()
          require("snacks").picker.grep {
            layout = "telescope",
          }
        end,
        desc = "Grep (Snacks)",
      },
      {
        "<leader>fr",
        function()
          require("snacks").picker.recent {
            layout = "telescope",
          }
        end,
        desc = "Recent files (Snacks)",
      },
      {
        "<leader>fk",
        function()
          require("snacks").picker.keymaps()
        end,
        desc = "Keymaps (Snacks)",
      },
      {
        "<leader>fc",
        function()
          require("snacks").picker.commands()
        end,
        desc = "Commands (Snacks)",
      },
      {
        "<leader>fs",
        function()
          require("snacks").picker.lsp_document_symbols()
        end,
        desc = "LSP Symbols (Snacks)",
      },
      {
        "<leader>fh",
        function()
          require("snacks").picker.help_tags()
        end,
        desc = "Help Tags (Snacks)",
      },
      {
        "<leader>fgc",
        function()
          require("snacks").picker.git_commits()
        end,
        desc = "Git Commits (Snacks)",
      },
      {
        "<leader>fgb",
        function()
          require("snacks").picker.git_branches()
        end,
        desc = "Git Branches (Snacks)",
      },
      {
        "<leader>fgs",
        function()
          require("snacks").picker.git_status()
        end,
        desc = "Git Status (Snacks)",
      },
    },
  },
}
