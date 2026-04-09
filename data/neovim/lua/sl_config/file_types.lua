local group = vim.api.nvim_create_augroup("filetype_custom", { clear = true })

local filetypes = {
    ["_service"] = "xml",
    ["*.g"] = "antlr3",
    ["*.g4"] = "antlr3",
    ["*.i"] = "c",
    ["*.ll"] = "llvm",
    ["*.td"] = "tablegen",
}

for pattern, ft in pairs(filetypes) do
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = group,
        pattern = pattern,
        command = "set filetype=" .. ft,
    })
end

