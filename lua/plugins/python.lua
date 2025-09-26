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

  -- Formatters with Conform - Fixed configuration
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "autopep8" }, -- Use autopep8 for Python formatting (preserves your style)
      },
      formatters = {
        autopep8 = {
          command = "autopep8",
          args = { 
            "--max-line-length", "120",  -- Match your preferred line length
            "-"  -- Read from stdin
          },
        },
      },
    },
  },

  -- Python linting with nvim-lint
  {
    "mfussenegger/nvim-lint", 
    opts = {
      linters_by_ft = {
        python = { "ruff" }, -- Use ruff for Python linting
      },
      linters = {
        ruff = {
          args = { 
            "check", 
            "--config", vim.fn.stdpath("config") .. "/ruff.toml",
            "--output-format", "text", 
            "--stdin-filename", "$FILENAME", 
            "-" 
          },
        },
      },
    },
  },
}
