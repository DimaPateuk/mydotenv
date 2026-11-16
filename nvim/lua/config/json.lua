if vim.fn.executable("jq") == 1 then
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("json_format", { clear = true }),
    pattern = "json",
    callback = function(args)
      vim.bo[args.buf].formatprg = "jq --indent 4 ."
    end,
  })
end
