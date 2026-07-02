return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- Configure diagnostics
		vim.diagnostic.config({
			virtual_text = {
				prefix = "■",
				spacing = 2,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			keys = {
				{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
			},
			root_markers = {
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				"Makefile",
				"configure.in",
				"config.h.in",
				"meson.build",
				"meson_options.txt",
				"build.ninja",
				".git",
			},
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--fallback-style=llvm",
			},
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = { "clangd", "lua_ls", "superhtml", "cssls", "emmet_ls", "ts_ls" },
			automatic_installation = true,
		})

		-- Setup lua_ls
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = { enable = false },
				},
			},
		})

		-- Setup SuperHTML (replaces vscode-html-language-server)
		vim.lsp.config("superhtml", {
			cmd = { "/home/angus/.local/share/nvim/mason/packages/superhtml/superhtml", "lsp" },
			capabilities = capabilities,
			filetypes = { "html", "htmldjango" },
		})

		-- Setup cssls
		vim.lsp.config("cssls", {
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" },
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				less = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		-- Setup ts_ls (JavaScript/TypeScript)
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
		})

		-- Setup emmet_ls
		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = { "html", "htmldjango", "css", "scss", "less", "javascriptreact", "typescriptreact" },
		})

		-- Auto-format on save for JS/TS
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})

		-- Auto-format on save for C/C++
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = {"*.c", "*.cpp", "*.h", "*.hpp"},
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})

		-- Auto-format on save for HTML/CSS with code block preservation
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = {"*.html", "*.css", "*.scss", "*.less"},
			callback = function()
				-- Skip code block preservation for non-HTML files
				if vim.bo.filetype ~= "html" and vim.bo.filetype ~= "htmldjango" then
					vim.lsp.buf.format({ async = false })
					return
				end
				
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				local code_blocks = {}
				local new_lines = {}
				local i = 1

				-- Replace code blocks with unique placeholders so formatting can't desync line numbers
				while i <= #lines do
					local line = lines[i]
					if line:match('<pre[^>]*>.*<code[^>]*>') and not line:match('</code>.*</pre>') then
						local block = {line}
						i = i + 1
						while i <= #lines and not lines[i]:match('</code>.*</pre>') do
							table.insert(block, lines[i])
							i = i + 1
						end
						if i <= #lines then
							table.insert(block, lines[i])
						end
						table.insert(code_blocks, block)
						table.insert(new_lines, '@@CODEBLOCK_' .. #code_blocks .. '@@')
						i = i + 1
					else
						table.insert(new_lines, line)
						i = i + 1
					end
				end

				vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)

				-- Format buffer with SuperHTML
				vim.lsp.buf.format({ async = false })

				-- Restore preserved code blocks by matching placeholders, not line numbers
				for idx, block in ipairs(code_blocks) do
					local placeholder = '@@CODEBLOCK_' .. idx .. '@@'
					local formatted = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					for j, l in ipairs(formatted) do
						if l:find(placeholder, 1, true) then
							vim.api.nvim_buf_set_lines(0, j - 1, j, false, block)
							break
						end
					end
				end
			end,
		})

		-- Enable auto-attachment for configured LSP servers
		vim.lsp.enable('clangd', 'lua_ls', 'superhtml', 'cssls', 'emmet_ls', 'ts_ls')
  	end,
}
