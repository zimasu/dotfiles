local map = vim.keymap.set

-- navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprev<CR>")
map("n", "<leader>x", ":bdelete<CR>")

-- better indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

-- lsp
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
map("n", "K",  vim.lsp.buf.hover)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- lazygit
map("n", "<leader>gg", "<cmd>!kitty --title lazygit -e lazygit<cr>")

-- notes
map("n", "<leader>nd", function()
  local date = os.date("%Y-%m-%d")
  local path = vim.fn.expand("~/notes/" .. date .. ".md")
  vim.cmd("e " .. path)
  -- auto populate template if file is empty
  if vim.fn.getfsize(path) <= 0 then
    local lines = {
      "## Today — " .. date,
      "",
      "### Must do",
      "- [ ] ",
      "- [ ] ",
      "- [ ] ",
      "",
      "### In progress",
      "- [ ] ",
      "",
      "### Done",
      "",
      "### Notes",
      "",
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end, { desc = "Open today's note" })
map("n", "<leader>nf", "<cmd>Telescope find_files cwd=~/notes<cr>", { desc = "Find notes" })
map("n", "<leader>ng", "<cmd>Telescope live_grep cwd=~/notes<cr>", { desc = "Grep notes" })

-- toggle checkbox
map("n", "<leader>tt", function()
  local line = vim.api.nvim_get_current_line()
  if line:match("%[ %]") then
    vim.api.nvim_set_current_line(line:gsub("%[ %]", "[x]"))
  elseif line:match("%[x%]") then
    vim.api.nvim_set_current_line(line:gsub("%[x%]", "[ ]"))
  end
end, { desc = "Toggle checkbox" })

-- AI / gen.nvim
map({ "n", "v" }, "<leader>ai", ":Gen Review_Code<CR>", { desc = "Explain code with AI" })
map({ "n", "v" }, "<leader>ar", ":Gen Summarize<CR>", { desc = "Review code with AI" })
