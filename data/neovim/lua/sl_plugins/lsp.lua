return {
    { "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
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
    end,
    },
}
