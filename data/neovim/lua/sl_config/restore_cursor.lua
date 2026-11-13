vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("sl_restore_cursor", { clear = true }),
  callback = function(args)
    -- filetype detection runs after this autocmd, so &ft is not set yet
    local ft = vim.filetype.match({ buf = args.buf }) or ""
    if ft:match("^git") or ft == "xxd" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
