local map = vim.keymap.set

map("n", "<leader>h", "<cmd>noh<CR>", { desc = "Clear search highlights" })

-- Colors mappings
vim.keymap.set("n", "<leader>tb", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle light/dark background" })

-- LSP results go to the quickfix list, which closes once an entry is picked
-- lsp_call receives the opts table, since methods take it in different positions
local function pick_and_close(lsp_call)
  return function()
    lsp_call({
      on_list = function(opts)
        vim.fn.setqflist({}, " ", { title = opts.title, items = opts.items, context = { close_on_pick = true } })
        if #opts.items == 1 then
          vim.cmd.cfirst()
        else
          vim.cmd.copen()
        end
      end,
    })
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(ev)
    map("n", "<CR>", function()
      local ctx = vim.fn.getqflist({ context = 0 }).context
      if vim.fn.win_gettype() == "quickfix" and type(ctx) == "table" and ctx.close_on_pick then
        vim.cmd(".cc")
        vim.cmd.cclose()
      else
        vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
      end
    end, { buffer = ev.buf })
  end,
})

-- LSP mappings
map("n", "gD",  vim.lsp.buf.definition)
map("n", "K",  vim.lsp.buf.hover)
map("n", "gi", pick_and_close(vim.lsp.buf.implementation))
map("n", "gr", pick_and_close(function(opts)
  vim.lsp.buf.references({ includeDeclaration = false }, opts)
end))
map("n", "gds", vim.lsp.buf.document_symbol)
map("n", "gws", vim.lsp.buf.workspace_symbol)
map("n", "<leader>cl", vim.lsp.codelens.run)
map("n", "<leader>sh", vim.lsp.buf.signature_help)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map(
	"n",
	"<leader>ih",
	function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
	{ desc = "Toggle inlay hints" }
)

-- all workspace diagnostics
map("n", "<leader>aa", vim.diagnostic.setqflist)

-- all workspace errors
map("n", "<leader>ae", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end)

-- all workspace warnings
map("n", "<leader>aw", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
end)

-- buffer diagnostics only
map("n", "<leader>d", vim.diagnostic.setloclist)

map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    vim.diagnostic.jump({ count = -1, wrap = false, float = true })
  end
end)

map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    vim.diagnostic.jump({ count = 1, wrap = false, float = true })
  end
end)

