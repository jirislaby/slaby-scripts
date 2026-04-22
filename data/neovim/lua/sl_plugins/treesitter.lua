return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
	    local ts = require("nvim-treesitter")
	    ts.setup()
	    vim.api.nvim_create_autocmd("FileType", {
		    callback = function() pcall(vim.treesitter.start) end,
	    })
	    ts.install({
		"asm",
		"bash",
		"cpp",
		"c",
		"cmake",
		"css",
		"diff",
		"dockerfile",
		"doxygen",
		"dtd",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"html",
		"json",
		"kconfig",
		"linkerscript",
		"llvm",
		"lua",
		"make",
		"markdown",
		"meson",
		"ninja",
		"objdump",
		"passwd",
		"perl",
		"python",
		"regex",
		"sql",
		"strace",
		"udev",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	    })
    end,
  },
}
