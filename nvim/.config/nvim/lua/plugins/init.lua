return {

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require "conform"
      local options = require "configs.conform-conf" -- ⬅️ modular config
      conform.setup(options)

      vim.keymap.set({ "n", "v" }, "<leader>l", function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end, { desc = "Format file or range" })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
        "typescript-language-server",
        "lua-language-server",
        "tailwindcss-language-server",
      },
    },
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {}, -- optional, plugin works with defaults
    lazy = false, -- optional: set to false if you want it loaded immediately
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  { "echasnovski/mini.nvim", version = "*" },

  {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return "AutoSave: saved at " .. vim.fn.strftime "%H:%M:%S"
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = { "InsertLeave", "TextChanged" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require "auto-save.utils.data"
        return fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {})
      end,
    },
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    -- config = function()
    --   require("your.null-ls.config") -- require your null-ls config here (example below)
    -- end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Extend or override opts
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "c",
        "cmake",
        "cpp",
        "css",
        "html",
        "javascript",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      })

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true

      opts.fold = {
        enable = true,
      }

      -- Set fold options once buffer is loaded, conditionally by line count
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          local line_count = vim.api.nvim_buf_line_count(0)
          if line_count < 200 then
            vim.opt.foldenable = false
          else
            vim.opt.foldenable = true
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldcolumn = "0"
            vim.opt.foldtext = ""
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 1
            vim.opt.foldnestmax = 4
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    ft = "markdown",
    config = true,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = false,
    init = function()
      -- Disable default mappings
      -- vim.g.VM_default_mappings = 0
    end,
    keys = {
      { "<C-F2>", "<Plug>(VM-Select-All)", mode = "n", desc = "Visual Multi: Select all occurrences" },
      { "<C-F2>", "<Plug>(VM-Visual-All)", mode = "x", desc = "Visual Multi: Select all (visual)" },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy", -- Optional: lazy load on demand
    config = function()
      require("oil").setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,

        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },

        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },

        win_options = {
          wrap = true,
          winblend = 0,
        },

        keymaps = {
          ["<C-c>"] = false,
          ["q"] = "actions.close",
        },
        use_default_keymaps = true, -- optional: enables telescope keymap automatically
      }
      -- Load Oil Telescope extension
      -- require("telescope").load_extension "oil"

      -- Optional keymap
      -- vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oil<cr>", { desc = "[F]ind [O]il" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "andrew-george/telescope-themes",
    },
    config = function()
      require "configs.telescope" -- ⬅️ move config logic here
    end,
  },

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
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          progress = { enabled = true },
          hover = { enabled = true },
          signature = { enabled = true },
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
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      require "configs.cmp"() -- add cmdline setup
    end,
  },

  {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
      vim.keymap.set("n", "<leader>gs", function()
        require("grug-far").open {
          engine = "astgrep",
          prefills = {
            paths = vim.fn.getcwd(), -- current working directory
          },
        }
      end, { desc = "grug-far: ast-grep in cwd" })
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
