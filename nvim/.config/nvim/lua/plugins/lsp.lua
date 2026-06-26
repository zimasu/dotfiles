return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config('clangd', { capabilities = capabilities })
      vim.lsp.config('rust_analyzer', { capabilities = capabilities })

      vim.lsp.enable({ 'clangd', 'rust_analyzer' })
    end,
  },
}
