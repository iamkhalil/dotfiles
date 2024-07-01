-- [[ Some basics ]]

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

vim.opt.showmatch = true -- Highlight matching brace
vim.opt.wildmenu = true -- Enable autocompletion in command mode
vim.opt.showmode = false

vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 999

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.errorbells = false
vim.opt.visualbell = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- copy/paste between vim and other program
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- search setting
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- preview substitution
vim.opt.inccommand = "split"

-- no help information needed when using the file explorer
vim.g.netrw_banner = 0

vim.opt.updatetime = 250
vim.opt.timeoutlen = 500 -- Displays which-key popup sooner

vim.g.have_nerd_font = true

-- [[ Keymaps ]]

vim.g.mapleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Shortcutting the file explorer
vim.keymap.set("n", "<leader>ve", "<cmd>Vexplore<CR>")
vim.keymap.set("n", "<leader>he", "<cmd>Sexplore<CR>")

vim.keymap.set("n", "<leader>tb", "<cmd>vert term bash<CR>")

-- Change 2 split windows from vert to horiz and vice versa
vim.keymap.set("n", "<leader>r", "<C-w>t<C-w>H")
vim.keymap.set("n", "<leader>R", "<C-w>t<C-w>K")

-- Make adjusting split sizes a bit more friendly
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +3<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -3<CR>", { silent = true })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +3<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -3<CR>", { silent = true })

-- Exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:q!<CR>")

-- Move selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Interactive renaming
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Quickfix mode
vim.keymap.set("n", "<C-k>", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "<C-j>", vim.diagnostic.goto_next, {})
vim.keymap.set(
  "n",
  "<leader>qk",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic error messages" }
)
vim.keymap.set(
  "n",
  "<leader>ql",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic quickfix list" }
)

-- [[ Autocommands ]]
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("BufWritePre", {
  desc = "Delete all trailing whitespace and newlines at end of file on save",
  group = augroup("buffer-ops", { clear = true }),
  pattern = "*",
  command = [[
    %s/\s\+$//e
    %s/\n\+\%$//e
  ]],
})

-- [[ Install lazy.nvim ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
  {
    "numToStr/Comment.nvim",
    opts = { -- Needed, otherwise no comments
      opleader = {
        line = "gc",
        block = "gb",
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    config = function()
      require("lualine").setup({
        -- options = {
        -- 	section_separators = '',
        -- 	component_separators = ''
        -- },
        sections = {
          lualine_c = { { "filename", path = 1 } },
        },
      })
    end,
  },
  {
    "nvchad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    config = function()
      require("colorizer").setup({
        user_default_options = { css = true },
      })
    end,
  },
  {
    "vimwiki/vimwiki",
    keys = { "<leader>ww", "<leader>wt" },
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/vimwiki/",
          syntax = "markdown",
          ext = "md",
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_refresh_slow = 1 -- refresh on save
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.surround").setup()
      require("mini.pairs").setup()
      require("mini.align").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "vimenter",
    branch = "0.1.x",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fw", builtin.grep_string)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)

      vim.keymap.set("n", "<leader>f/", function()
        builtin.find_files({ cwd = "~", hidden = true })
      end)

      vim.keymap.set("n", "<leader>f.", function()
        builtin.find_files({ cwd = "~/.config" })
      end)

      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSupdate",
    event = { "bufreadpre", "bufnewfile" },
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "cpp",
          "html",
          "javascript",
          "lua",
          "luadoc",
          "markdown",
          "python",
          "typescript",
          "vimdoc",
        },
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- disable = {}
        },
        indent = { enable = true, disable = { "c", "cpp" } },
      })
    end,
  },
  { -- Similar to Emacs Dired in the way he treats fs like a buffer
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local detail = true
      require("oil").setup({
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<leader>ll"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set(
        "n",
        "<leader>-",
        require("oil").toggle_float,
        { desc = "Open Oil in a floating window" }
      )
    end,
  },
  { -- LSP
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function()
          local builtin = require("telescope.builtin")

          vim.keymap.set("n", "gd", builtin.lsp_definitions) --  To jump back, press <C-t>.
          vim.keymap.set("n", "gr", builtin.lsp_references)
          vim.keymap.set("n", "gD", builtin.lsp_type_definitions)

          vim.keymap.set("n", "gh", vim.lsp.buf.declaration)
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
          vim.keymap.set("n", "K", vim.lsp.buf.hover)
        end,
      })

      -- Enhance neovim capabilities using nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities =
        vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = { -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
        clangd = {
          filetypes = {
            -- "c",
            "cpp",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities =
              vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  { -- Formatting
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require("conform").setup({
        notify_on_error = false,
        formatters_by_ft = {
          lua = { "stylua" },
        },
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
      })
    end,
  },
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    lazy = false,
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
})
