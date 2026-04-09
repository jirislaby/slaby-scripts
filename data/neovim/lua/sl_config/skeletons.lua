local group = vim.api.nvim_create_augroup("skeletons_custom", { clear = true })

local function insert_interpreter(interp)
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/" .. interp })
end

-- local function set_executable_bit(file)
--     vim.cmd("checktime")
--     -- Simulace původního autocmd pro potlačení hlášení změny shellu
--     vim.api.nvim_create_autocmd("FileChangedShell", {
--         pattern = file,
--         command = "echo",
--         once = true,
--     })
--     vim.api.nvim_buf_set_option(0, "autoread", true)
--     vim.fn.system("chmod a+x " .. vim.fn.shellescape(file))
--     vim.cmd("checktime")
-- end

if vim.fn.filereadable("/usr/share/slaby-scripts/skeleton/skeleton.c") == 1 then
    local skeletons = {
        ["CMakeLists.txt"] = "CMakeLists.txt",
        ["meson.build"] = "meson.build",
        ["meson.options"] = "meson.options",
        ["*.c"] = "skeleton.c",
        ["*.cpp"] = "skeleton.cpp",
        ["*.pl"] = "skeleton.pl",
    }
    for pattern, file in pairs(skeletons) do
        vim.api.nvim_create_autocmd("BufNewFile", {
            group = group,
            pattern = pattern,
            command = "0r /usr/share/slaby-scripts/skeleton/" .. file,
        })
    end
end

-- Interpretry a Executable bit
vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = "*.py",
    callback = function() insert_interpreter("python3") end,
})
vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = "*.sh",
    callback = function() insert_interpreter("bash") end,
})
-- vim.api.nvim_create_autocmd("BufNewFile", {
--     group = group,
--     pattern = { "*.pl", "*.py", "*.sh" },
--     callback = function() set_executable_bit(vim.fn.expand("<afile>:p")) end,
-- })

