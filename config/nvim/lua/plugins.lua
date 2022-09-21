require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("jparise/vim-graphql")
	use("terrortylor/nvim-comment")
	use("bronson/vim-visual-star-search")
	use("lambdalisue/fern.vim")
	use({
		"acro5piano/nvim-format-buffer",
		config = function()
			require("nvim-format-buffer").setup({
				format_rules = {
					{ pattern = { "*.lua" }, command = "stylua -" },
					{ pattern = { "*.py" }, command = "black -q - | isort -" },
					{
						pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
						command = "prettier --parser typescript 2>/dev/null",
					},
					{ pattern = { "*.md" }, command = "prettier --parser markdown 2>/dev/null" },
					{ pattern = { "*.css" }, command = "prettier --parser css" },
					{ pattern = { "*.rs" }, command = "rustfmt --edition 2021" },
					{ pattern = { "*.sql" }, command = "sql-formatter --config ~/sql-formatter.json" }, -- requires `npm -g i sql-formatter`
				},
			})
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.vimls.setup({
				on_attach = require("aerial").on_attach,
			})
			lspconfig.pyright.setup({
				on_attach = require("aerial").on_attach,
			})
			lspconfig.sumneko_lua.setup({
				on_attach = require("aerial").on_attach,
			})
			lspconfig.rust_analyzer.setup({
				on_attach = require("aerial").on_attach,
			})
		end,
	})

	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local opt = {
						-- -- Function executed when the LSP server startup
						-- on_attach = function(client, bufnr)
						--   local opts = { noremap=true, silent=true }
						--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
						--   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
						-- end,
						capabilities = require("cmp_nvim_lsp").update_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
					}
					require("lspconfig")[server].setup(opt)
				end,
			})
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					-- { name = "buffer" },
					-- { name = "path" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				experimental = {
					ghost_text = true,
				},
			})
		end,
	})
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("tpope/vim-surround")
	use("dcampos/nvim-snippy")
	use("dcampos/cmp-snippy")
	use("rcarriga/nvim-notify")
	use({ "kevinhwang91/nvim-hlslens" })
	use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })
	use("myusuf3/numbers.vim")
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.opt.termguicolors = true
			vim.cmd([[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]])
			vim.cmd([[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]])

			require("indent_blankline").setup({
				char = "",
				char_highlight_list = {
					"IndentBlanklineIndent1",
					"IndentBlanklineIndent2",
				},
				space_char_highlight_list = {
					"IndentBlanklineIndent1",
					"IndentBlanklineIndent2",
				},
				show_trailing_blankline_indent = false,
			})
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set(
				"n",
				"<leader>ff",
				[[<Cmd>lua require('telescope.builtin').find_files()<CR>]],
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fg",
				[[<Cmd>lua require('telescope.builtin').live_grep()<CR>]],
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fb",
				[[<Cmd>lua require('telescope.builtin').buffers()<CR>]],
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fh",
				[[<Cmd>lua require('telescope.builtin').help_tags()<CR>]],
				{ noremap = true }
			)
			vim.keymap.set("n", "<leader>fs", [[<Cmd>Telescope frecency<cr>]], { noremap = true })
		end,
	})
	use("kyazdani42/nvim-web-devicons")
	use("nvim-treesitter/nvim-treesitter")
	use("yioneko/nvim-yati")
	use("kkharji/sqlite.lua")

	use({
		"nvim-telescope/telescope-packer.nvim",
		config = function()
			require("telescope").load_extension("packer")
		end,
	})
	use({
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "kkharji/sqlite.lua" },
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
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
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	})
	use({
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
		config = function()
			local navic = require("nvim-navic")
			require("lspconfig").clangd.setup({
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
			})
		end,
	})

	use({
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					-- Toggle the aerial window with <leader>a
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
					-- Jump forwards/backwards with '{' and '}'
					vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
					vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
					-- Jump up the tree with '[[' or ']]'
					vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
					vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
				end,
			})
		end,
	})
end)

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] =
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })
-- Reference highlight
vim.cmd([[
set updatetime=500
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]])
