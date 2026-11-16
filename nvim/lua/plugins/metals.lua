local api = vim.api

-- Jump to the location attached to an inlay hint on the cursor line, like
-- clicking a hint in VS Code (e.g. the implicit decoder picked for `.as[T]`).
local function goto_inlay_hint_definition(client)
  local bufnr = api.nvim_get_current_buf()
  local row = api.nvim_win_get_cursor(0)[1] - 1
  local hints = vim.lsp.inlay_hint.get({
    bufnr = bufnr,
    range = { start = { line = row, character = 0 }, ["end"] = { line = row + 1, character = 0 } },
  })

  local targets = {}
  for _, h in ipairs(hints) do
    local hint = h.inlay_hint
    if type(hint.label) == "table" and client:supports_method("inlayHint/resolve") then
      local resp = client:request_sync("inlayHint/resolve", hint, 1000, bufnr)
      if resp and resp.result then hint = resp.result end
    end
    if type(hint.label) == "table" then
      for _, part in ipairs(hint.label) do
        -- Metals sends the target as a command whose argument is a Location
        local arg = part.command and part.command.arguments and part.command.arguments[1]
        if part.location then
          table.insert(targets, { name = part.value, location = part.location })
        elseif type(arg) == "table" and arg.uri and arg.range then
          table.insert(targets, { name = part.value, location = arg })
        elseif part.command then
          table.insert(targets, { name = part.value, command = part.command })
        end
      end
    end
  end

  local function jump(target)
    if target.location then
      vim.lsp.util.show_document(target.location, client.offset_encoding, { focus = true })
    else
      client:exec_cmd(target.command, { bufnr = bufnr })
    end
  end

  if #targets == 0 then
    vim.notify("No inlay hint with a location on this line", vim.log.levels.INFO)
  elseif #targets == 1 then
    jump(targets[1])
  else
    vim.ui.select(targets, {
      prompt = "Inlay hint target",
      format_item = function(t) return t.name end,
    }, function(choice) if choice then jump(choice) end end)
  end
end

-- Jump to the next/previous `case` of the match enclosing the cursor. Moves
-- between sibling case_clause nodes, so cases of nested matches are skipped.
local function goto_case(forward)
  local node = vim.treesitter.get_node()
  while node and node:type() ~= "case_clause" do node = node:parent() end
  if not node then
    vim.notify("Not inside a match case", vim.log.levels.INFO)
    return
  end

  local sibling = forward and node:next_named_sibling() or node:prev_named_sibling()
  while sibling and sibling:type() ~= "case_clause" do
    sibling = forward and sibling:next_named_sibling() or sibling:prev_named_sibling()
  end
  if not sibling then return end

  local row, col = sibling:start()
  vim.cmd("normal! m'") -- add to the jumplist so <C-o> goes back
  api.nvim_win_set_cursor(0, { row + 1, col })
end

return {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
        local metals_config = require("metals").bare_config()

	-- Example of settings
	metals_config.settings = {
	  serverVersion = "2.0.0-M19",
	  serverProperties = { "-Xmx4g" },
	  inlayHints = {
	    implicitArguments = { enable = true },
	    implicitConversions = { enable = true },
	    inferredTypes = { enable = true },
	  },
	  enableSemanticHighlighting = true,
	  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
	}

	-- *READ THIS*
	-- I *highly* recommend setting statusBarProvider to true, however if you do,
	-- you *have* to have a setting to display this in your statusline or else
	-- you'll not see any messages from metals. There is more info in the help
	-- docs about this
	metals_config.init_options.statusBarProvider = "on"

	-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
	metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
	
	-- Debug settings if you're using nvim-dap
	local dap = require("dap")

	dap.configurations.scala = {
	  {
	    type = "scala",
	    request = "launch",
	    name = "RunOrTest",
	    metals = {
	      runType = "runOrTestFile",
	    },
	  },
	  {
	    type = "scala",
	    request = "launch",
	    name = "Test Target",
	    metals = {
	      runType = "testTarget",
	    },
	  },
	}

	dap.listeners.after.event_initialized["open_repl"] = function()
	  dap.repl.open()
	end

	metals_config.on_attach = function(client, bufnr)
	  require("metals").setup_dap()

	  if client:supports_method("textDocument/foldingRange") then
	    local win = api.nvim_get_current_win()
	    vim.wo[win][0].foldmethod = "expr"
	    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
	  end

	  local map = vim.keymap.set
	  map("v", "K", function() require("metals").type_of_range() end, { buffer = bufnr, desc = "Metals type of selection" })
	  map("n", "<leader>ws", function() require("metals").hover_worksheet() end, { buffer = bufnr, desc = "Metals hover worksheet" })
	  map("n", "<leader>gh", function() goto_inlay_hint_definition(client) end, { buffer = bufnr, desc = "Go to definition of inlay hint (e.g. implicit)" })
	  map("n", "]k", function() goto_case(true) end, { buffer = bufnr, desc = "Next match case" })
	  map("n", "[k", function() goto_case(false) end, { buffer = bufnr, desc = "Previous match case" })
	  map("n", "<leader>dc", function() require("dap").continue() end, { buffer = bufnr, desc = "DAP continue" })
	  map("n", "<leader>dr", function() require("dap").repl.toggle() end, { buffer = bufnr, desc = "DAP REPL toggle" })
	  map("n", "<leader>dK", function() require("dap.ui.widgets").hover() end, { buffer = bufnr, desc = "DAP hover" })
	  map("n", "<leader>dt", function() require("dap").toggle_breakpoint() end, { buffer = bufnr, desc = "DAP toggle breakpoint" })
	  map("n", "<leader>dso", function() require("dap").step_over() end, { buffer = bufnr, desc = "DAP step over" })
	  map("n", "<leader>dsi", function() require("dap").step_into() end, { buffer = bufnr, desc = "DAP step into" })
	  map("n", "<leader>dl", function() require("dap").run_last() end, { buffer = bufnr, desc = "DAP run last" })

	  if client.server_capabilities.documentHighlightProvider then
	    local highlight_group = api.nvim_create_augroup("lsp-document-highlight", { clear = false })
	    api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })
	    api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	      group = highlight_group,
	      buffer = bufnr,
	      callback = vim.lsp.buf.document_highlight,
	    })
	    api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	      group = highlight_group,
	      buffer = bufnr,
	      callback = vim.lsp.buf.clear_references,
	    })
	  end
	end

	-- Autocmd that will actually be in charging of starting the whole thing
	local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
	api.nvim_create_autocmd("FileType", {
	  -- NOTE: You may or may not want java included here. You will need it if you
	  -- want basic Java support but it may also conflict if you are using
	  -- something like nvim-jdtls which also works on a java filetype autocmd.
	  pattern = { "scala", "sbt", "java" },
	  callback = function()
	    require("metals").initialize_or_attach(metals_config)
	  end,
	  group = nvim_metals_group,
	})

     end
  }


