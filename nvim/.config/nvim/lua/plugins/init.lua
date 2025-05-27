return {

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- or "VeryLazy"
    config = function()
      require("conform").setup(require "configs.conform")
    end,
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
      "vim", "lua", "vimdoc", "html", "css",
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
}

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
