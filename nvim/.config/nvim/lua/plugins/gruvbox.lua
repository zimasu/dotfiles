return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      contrast = "hard",
      italic = {
        strings   = false,
        emphasis  = false,
        comments  = true,
        operators = false,
        folds     = true,
      },
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
