-- ~/.config/nvim/init.lua
-- Minimal, blank-slate Neovim configuration

-- Leader key (optional, but useful for custom maps)
vim.g.mapleader = " "

-- Basic settings for a sane baseline
vim.opt.number = true       -- show line numbers
vim.opt.relativenumber = true
vim.opt.termguicolors = true -- enable true color support

-- Flash yanked region (built-in Neovim feature)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

----------------------------------------------------------
-- System clipboard integration (pasteboard)
----------------------------------------------------------
-- Use the system clipboard for all yanks/deletes/puts by default
vim.opt.clipboard = "unnamedplus"

-- Optional, explicit keymaps to interact with the + register
local map, opts = vim.keymap.set, { noremap = true, silent = true }
map({"n","x"}, "<leader>y", '"+y', opts) -- yank to system clipboard
map("n", "<leader>Y", '"+Y', opts)
map({"n","x"}, "<leader>p", '"+p', opts) -- paste from system clipboard
map({"n","x"}, "<leader>P", '"+P', opts)




----------------------------------------------------------
-- Plugins
----------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)


-- Plugins (minimal): yank highlight only, lazy-loaded on TextYankPost
require("lazy").setup({
})

