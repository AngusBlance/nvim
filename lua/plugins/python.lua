return {
  -- LSP servers via mason-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- optional tweaks
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "strict",
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {}, -- modern Ruff language server (not ruff-lsp)
      },
      setup = {
        -- Example: make Ruff handle imports/organise, let basedpyright do hover/defs
        ruff = function() end,
        basedpyright = function() end,
      },
    },
  },

  -- Formatters with Conform (LazyVim default)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" }, -- or { "black" } if you prefer
      },
    },
  },

  -- Linters with nvim-lint (optional if you rely on Ruff LSP diagnostics)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },
}
