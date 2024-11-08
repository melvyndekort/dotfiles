require("lazy").setup({

  -- Neovim-sensible for sensible defaults
  {
    "jeffkreeftmeijer/neovim-sensible",
  },

  -- Dracula theme
  {
    "dracula/vim",
    as = "dracula",
    config = function()
      vim.cmd("colorscheme dracula")
    end,
  },

  -- Telescope plugin with dependencies
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required dependency for Telescope
      "nvim-tree/nvim-web-devicons",  -- Optional: for file icons
    },
    config = function()
      require('telescope').setup {
        extensions = {
          -- Enable extensions like fzf, git, etc.
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
          },
        },
      }
      -- Load Telescope extensions
      require("telescope").load_extension("fzf")
    end
  },

  -- Telescope fzf-native extension
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",  -- fzf-native needs to be compiled after installation
    config = function()
      -- Ensure the extension is loaded after installation
      require('telescope').load_extension('fzf')
    end
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- vim-illuminate for word highlighting
  {
    "RRethy/vim-illuminate",
    config = function()
      -- Automatically highlight all occurrences of the word under the cursor
      vim.g.Illuminate_ftblacklist = { "NvimTree", "packer" }  -- Don't highlight in these filetypes
    end
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
      })
    end,
  },

  -- LSP support with 'nvim-lspconfig'
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup({}) -- Python LSP example
    end,
  },

  -- Bufferline for buffer tabs
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- For file icons
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "NvimTree", -- Offset for the file explorer (if used)
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          show_buffer_icons = true, -- Show icons for buffers
          show_buffer_close_icons = true, -- Show close icons for buffers
          show_close_icon = false, -- Hide the close icon for the bufferline itself
          separator_style = "thin", -- Separator style between buffers
        },
      })
    end,
  },

})
