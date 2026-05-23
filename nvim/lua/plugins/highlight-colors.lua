return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      exclude_buftypes = {
        "help",
        "nofile",
        "prompt",
        "quickfix",
      },
      exclude_buffer = function(bufnr)
        return not vim.api.nvim_buf_is_loaded(bufnr)
      end,
    })
  end,
}
