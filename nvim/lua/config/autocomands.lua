local opts = { noremap = true, silent = true }

-- Go between buffers in terminal normal mode
local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "t" }, "<S-h>", "<Cmd>bprevious<CR>", opts)
vim.keymap.set({ "n", "t" }, "<S-l>", "<Cmd>bnext<CR>", opts)

-- quick save
vim.keymap.set("n", "<leader>w", ":w<CR>", opts)

-- delete current buffer
vim.keymap.set("n", "<leader>bd", ":bd<CR>", opts)

-- Split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Terminal mode mapping: Esc to Normal mode
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Disable split navigation inside plugin UI windows (Mason, lazy, etc.)
-- Also normalise double-click to single-click in Mason so clicking a package
-- doesn't trigger visual word selection across two entries.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mason", "lazy", "lspinfo" },
  callback = function(ev)
    for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
      vim.keymap.del("n", key, { buffer = ev.buf })
    end
    vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse>", { buffer = ev.buf, silent = true })
  end,
})
