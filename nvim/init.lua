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

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, 'Next hunk')
				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, 'Prev hunk')
				map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
				map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
				map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
			end,
		},
	},
})
