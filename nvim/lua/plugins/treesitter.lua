return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/nix-treesitter",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      for _, cmd in ipairs({ "TSInstall", "TSInstallSync", "TSUpdate", "TSUpdateSync" }) do
        pcall(vim.api.nvim_del_user_command, cmd)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
  },
}
