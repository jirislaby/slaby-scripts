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

	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
	})
	vim.lsp.enable("lua_ls")

	vim.lsp.config("pyright", {
	    capabilities = capabilities,
	    settings = {
		python = {
		    analysis = {
			autoSearchPaths = true,
			useLibraryCodeForTypes = true,
			diagnosticMode = "workspace",
		    },
		},
	    },
	})
	vim.lsp.enable("pyright")

	vim.lsp.enable("rust_analyzer")
    end,
    },
}
