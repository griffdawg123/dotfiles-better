-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  -- or, branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
      "rebelot/kanagawa.nvim",
	  as = 'kanagawa',
	  config = function()
		  vim.cmd('colorscheme kanagawa')
	  end
  }
  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use ('theprimeagen/harpoon')
  use ('mbbill/undotree')
  use ('tpope/vim-fugitive')
  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  requires = {
    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    -- {'williamboman/mason.nvim'},
    -- {'williamboman/mason-lspconfig.nvim'},

    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
}
}
use ('williamboman/mason.nvim')
use ('williamboman/mason-lspconfig.nvim')
use ('tpope/vim-commentary')
use ('nvim-tree/nvim-web-devicons')
use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}
use ('folke/trouble.nvim')
use ('stevearc/oil.nvim')
use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
use ('christoomey/vim-tmux-navigator')
use ("R-nvim/R.nvim")
use ("R-nvim/cmp-r")
use {
    'vim-test/vim-test',
    requires = {
        'preservim/vimux'
    }
}
use ("tpope/vim-surround")
use ("mfussenegger/nvim-jdtls")
use ( 'norcalli/nvim-colorizer.lua' )
end)
