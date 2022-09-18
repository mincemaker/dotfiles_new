require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("jparise/vim-graphql")
	use("terrortylor/nvim-comment")
	use("nvim-lualine/lualine.nvim")
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

	use {
	  'nvim-telescope/telescope.nvim',
	  requires = {'nvim-lua/plenary.nvim'} ,
    config = function()
      vim.keymap.set('n', '<leader>ff', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fb', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], {noremap = true})
      vim.keymap.set('n', '<leader>fh', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], {noremap = true})
      vim.keymap.set('n', '<C-f>', [[<Cmd>Telescope frecency<cr>]], {noremap = true})
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
end)

