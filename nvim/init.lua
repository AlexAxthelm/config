-- ~/.config/nvim/init.lua

-- Leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = "menu,menuone,noselect" -- recommended for nvim-cmp UX

-- Prefer vertical splits for diffs and windows
vim.opt.diffopt:append("vertical")
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Optional explicit clipboard maps
local map, mopts = vim.keymap.set, { noremap = true, silent = true }
map({"n","x"}, "<leader>y", '"+y', mopts)
map("n", "<leader>Y", '"+Y', mopts)
map({"n","x"}, "<leader>p", '"+p', mopts)
map({"n","x"}, "<leader>P", '"+P', mopts)

-- Highlight on yank (built-in Neovim feature)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})


-- ── Indentation & wrapping defaults ──────────────────────────────────────────
vim.opt.expandtab   = true   -- spaces, not literal tabs (globally)
vim.opt.shiftwidth  = 2      -- >> and autoindent = 2 spaces
vim.opt.tabstop     = 2      -- a <Tab> shows as 2 spaces
vim.opt.softtabstop = 2
vim.opt.textwidth   = 80     -- reflow width for gq
vim.opt.formatoptions = "jcroql" 
-- j: remove comment leader when joining
-- c: auto-wrap comments using textwidth while typing
-- r: continue comment when hitting <CR>
-- o: continue comment after 'o' or 'O'
-- q: allow formatting with gq
-- l: don’t break long lines in insert if it would split a long word

-- Tip: reindent whole file: gg=G
-- Tip: reflow to textwidth: gq (e.g., vipgq to format a paragraph)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colors: Base16 Solarized Light
  {
    "RRethy/nvim-base16",
    priority = 1000,      -- load early
    config = function()
      vim.o.background = "light"
      vim.cmd.colorscheme("base16-solarized-light")
    end,
  },

  -- Git signs (gitgutter-like signs + extra features)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Expressive signs similar to gitgutter
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = true,
      numhl = true,          -- set to true if you prefer number column highlighting
      linehl = false,         -- set to true to highlight entire changed lines
      word_diff = true,       -- intra-line diff for changed hunks

      -- Blame (inline, subtle, at end of line)
      current_line_blame = true,
      current_line_blame_opts = { delay = 500, virt_text_pos = 'eol' },
      -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> • <summary>',

      -- Performance / behavior
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function nmap(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc }) end
        local function vmap(lhs, rhs, desc) vim.keymap.set('v', lhs, rhs, { buffer = bufnr, desc = desc }) end

        -- Hunk navigation
        nmap(']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(gs.next_hunk)
          return '<Ignore>'
        end, 'Next hunk')
        nmap('[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(gs.prev_hunk)
          return '<Ignore>'
        end, 'Prev hunk')

        -- Stage / reset (line or visual selection)
        nmap('<leader>hs', gs.stage_hunk, 'Stage hunk')
        nmap('<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        nmap('<leader>hr', gs.reset_hunk, 'Reset hunk')
        vmap('<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage selection')
        vmap('<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset selection')
        nmap('<leader>hS', gs.stage_buffer, 'Stage buffer')
        nmap('<leader>hR', gs.reset_buffer, 'Reset buffer')

        -- Info / preview / diff
        nmap('<leader>hp', gs.preview_hunk, 'Preview hunk')
        nmap('<leader>hb', gs.blame_line, 'Blame line')
        nmap('<leader>hd', gs.diffthis, 'Diff this')
        nmap('<leader>hD', function() gs.diffthis('~') end, 'Diff against HEAD~')

        -- Quick toggles
        nmap('<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
        nmap('<leader>tn', gs.toggle_numhl, 'Toggle number highlight')
        nmap('<leader>tl', gs.toggle_linehl, 'Toggle line highlight')
        nmap('<leader>tw', gs.toggle_word_diff, 'Toggle word diff')
      end,
    },
  },

  -- tmux navigation (like your old setup). Lazy-loads on first Ctrl-h/j/k/l.
  {
    "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
  },

  -- completion (cmp) — buffer + path sources only
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",      -- snippet engine (required by cmp)
      "hrsh7th/cmp-buffer",    -- buffer words
      "hrsh7th/cmp-path",      -- filesystem paths
      "andersevenrud/cmp-tmux" -- completion from tmux panes
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>']      = cmp.mapping.confirm({ select = true }),
          ['<Tab>']     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>']   = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'path' },     -- filesystem paths
          { name = 'tmux' },     -- words from tmux panes
          {
            name = 'buffer',     -- common words from all open buffers
            option = {
              -- Use all listed buffers as completion sources, not just the current one.
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
      })
    end,
  },

  -- Fugitive: git porcelain and commit helpers
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gblame", "Glog" }
  },


  -- Committia: show git diff beside commit message buffer
  {
    "rhysd/committia.vim",
    ft = "gitcommit",
    init = function()
      -- Only open the fancy layout when Neovim is launched as $GIT_EDITOR
      -- (keeps things quiet if you open COMMIT_EDITMSG within an existing session)
      vim.g.committia_open_only_vim_starting = 1
      -- Wider layouts feel better; tweak to taste
      vim.g.committia_min_window_width = 120
    end,
  },

  ------------------------------------------------------------------
  -- TOP BAR (tabs) & ICONS
  ------------------------------------------------------------------

  -- Bufferline as a tab bar (buffers as tabs). Shows filename, modified, close, etc.
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = false,
        separator_style = "thin",
        always_show_bufferline = true,
        mode = "tabs",
        offsets = {},
      },
    },
  },

  -- Surround (Lua drop-in for tpope/vim-surround)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",      -- loads after UI settles; instant on first use
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Comment.nvim (drop-in Lua version of tpope/vim-commentary)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup({})
      -- Default keymaps:
      --   gcc  → toggle comment on current line
      --   gc   → toggle comment on selection (visual mode)
      -- These match vim-commentary muscle memory.
    end,
  },


})


-- Optional: quick key to start a commit inside Neovim
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { silent = true, desc = 'Git commit (Fugitive)' })
