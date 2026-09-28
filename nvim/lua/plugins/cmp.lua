return {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
	    local cmp = require("cmp")
	    cmp.setup({
	      sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
	      },
	      snippet = {
		expand = function(args)
		  vim.fn["vsnip#anonymous"](args.body)
		end,
	      },
	      mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = function(fallback)
		  if cmp.visible() then
		    cmp.select_next_item()
		  else
		    fallback()
		  end
		end,
		["<S-Tab>"] = function(fallback)
		  if cmp.visible() then
		    cmp.select_prev_item()
		  else
		    fallback()
		  end
		end,
	      }),
	    })
	  end,
  }
