local map = vim.keymap.set

-- F klávesy (předchozí/další soubor, překlad, chyby)
-- map({ "n", "i" }, "<F3>", "<Esc>:wN<CR>")
-- map({ "n", "i" }, "<F4>", "<Esc>:wn<CR>")
-- map({ "n", "i" }, "<F5>", function() return vim.fn.mode() == "i" and "<Esc>l[si" or "[s" end, { expr = true })
-- map({ "n", "i" }, "<F6>", function() return vim.fn.mode() == "i" and "<Esc>l]si" or "]s" end, { expr = true })
map({ "n", "i" }, "<F7>", "<Esc>:mak<CR>")
-- map({ "n", "i" }, "<C-F7>", "<Esc>:mak!<CR>")

-- Editace řádku (C-K, C-U)
map("i", "<C-K>", "<Esc>lc<End>")
map("i", "<C-U>", "<Esc>ld<Home>")
map("n", "<C-K>", "d<End>")
map("n", "<C-U>", "d<Home>")

-- Speciální operace s diffy/změnami
map("n", "<leader>N", "?^@@<CR>V/^@@\\|\\%$<CR>:s/^[- ]//n<CR>")
map("n", "<leader>M", "?^@@<CR>V/^@@\\|\\%$<CR>:s/^[+ ]//n<CR>")
