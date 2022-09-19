require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("jparise/vim-graphql")
	use("terrortylor/nvim-comment")
	use("bronson/vim-visual-star-search")
	use("lambdalisue/fern.vim")
	use("acro5piano/nvim-format-buffer")
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("tpope/vim-surround")
	use("dcampos/nvim-snippy")
	use("dcampos/cmp-snippy")
  use("rcarriga/nvim-notify")
  use {'kevinhwang91/nvim-hlslens'}
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}


	use {
	  'nvim-telescope/telescope.nvim',
	  requires = {'nvim-lua/plenary.nvim'} ,
    config = function()
      vim.keymap.set('n', '<leader>ff', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fb', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fh', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fs', [[<Cmd>Telescope frecency<cr>]], {noremap = true})
    end,
	}
  use("kyazdani42/nvim-web-devicons")
  use("nvim-treesitter/nvim-treesitter")
  use("kkharji/sqlite.lua")
  use {
    "nvim-telescope/telescope-packer.nvim",
    config = function()
      require"telescope".load_extension("packer")
    end,
  }
  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require"telescope".load_extension("frecency")
    end,
    requires = {"kkharji/sqlite.lua"}
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  }
  use {
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
      config = function()
        local navic = require("nvim-navic")

        require("lspconfig").clangd.setup {
            on_attach = function(client, bufnr)
                navic.attach(client, bufnr)
            end
        }
      end
  }


end)


