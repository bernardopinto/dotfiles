return {
  "AlexandrosAlexiou/kotlin.nvim",
  ft = { "kotlin" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Force-stop the Kotlin LSP on nvim exit. The JVM is slow to honor
    -- LSP shutdown within nvim's default exit_timeout, which leaves the
    -- process orphaned to launchd.
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("kotlin_lsp_cleanup", { clear = true }),
      callback = function()
        for _, client in ipairs(vim.lsp.get_clients({ name = "kotlin_ls" })) do
          pcall(function()
            client:stop(true)
          end)
        end
      end,
    })

    require("kotlin").setup({
      root_markers = {
        "gradlew",
        ".git",
        "mvnw",
        "settings.gradle",
      },
      jre_path = nil,
      jdk_for_symbol_resolution = nil,
      jvm_args = {
        "-Xmx4g",
      },
      inlay_hints = {
        enabled = true,
        parameters = true,
        parameters_compiled = true,
        parameters_excluded = false,
        types_property = true,
        types_variable = true,
        function_return = true,
        function_parameter = true,
        lambda_return = true,
        lambda_receivers_parameters = true,
        value_ranges = true,
        kotlin_time = true,
      },
    })
  end,
}
