return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "                                                     ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  Today's Note", "<cmd>lua vim.cmd('e ~/notes/' .. os.date('%Y-%m-%d') .. '.md')<cr>"),
      dashboard.button("f", "  Find File",    "<cmd>Telescope find_files<cr>"),
      dashboard.button("g", "  Grep Notes",   "<cmd>Telescope live_grep cwd=~/notes<cr>"),
      dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("e", "  File Tree",    "<cmd>Neotree toggle<cr>"),
      dashboard.button("q", "  Quit",         "<cmd>qa<cr>"),
    }

    alpha.setup(dashboard.config)
  end,
}
