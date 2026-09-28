local api = vim.api
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
	  showImplicitArguments = true,
	  showImplicitConversionsAndClasses = true,
	  showInferredType = true,
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


