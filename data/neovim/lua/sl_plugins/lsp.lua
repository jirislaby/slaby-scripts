return {
    { "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
	vim.keymap.set('n', '<F4>', '<cmd>LspClangdSwitchSourceHeader<cr>',
		       { desc = 'Switch between .h and .cpp' })
	vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = "Go to definition" })
	vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = "Go to declaraction" })

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	vim.lsp.config("clangd", {
	    capabilities = capabilities,
	})
	vim.lsp.enable("clangd")

	vim.lsp.config("cssls", {
		cmd = { "vscode-css-languageserver", "--stdio" },
	})
	vim.lsp.enable("cssls")

	vim.lsp.config("html", {
		cmd = { "vscode-html-languageserver", "--stdio" },
	})
	vim.lsp.enable("html")

	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
	})
	vim.lsp.enable("lua_ls")

	-- vim.lsp.config("pyright", {
	--     capabilities = capabilities,
	--     settings = {
	-- 	python = {
	-- 	    analysis = {
	-- 		autoSearchPaths = true,
	-- 		useLibraryCodeForTypes = true,
	-- 		diagnosticMode = "workspace",
	-- 	    },
	-- 	},
	--     },
	-- })
	-- vim.lsp.enable("pyright")

	vim.lsp.config("pylsp", {
		cmd = { "pylsp" },
		capabilities = capabilities,
		settings = {
			pylsp = {
				plugins = {
					pycodestyle = { enabled = false },
					pyflakes = { enabled = false },
					mccabe = { enabled = false },

					ruff = {
						enabled = true,
						formatEnabled = true,
					},

					pylsp_mypy = {
						enabled = true,
						live_mode = true,
						strict = false,
					},
				},
			},
		},
	})
	vim.lsp.enable("pylsp")

	vim.lsp.config("rpm_spec_ls", {
		cmd = { "rpm_lsp_server" },
		filetypes = { "spec" },
		capabilities = capabilities,
		root_markers = { ".git", "*.spec" },
	})
	vim.lsp.enable("rpm_spec_ls")

	vim.lsp.enable("rust_analyzer")
    end,
    },
}
