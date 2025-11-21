-- ~/.config/nvim/init.lua

-- Leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

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
})
