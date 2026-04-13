if vim.fn.filereadable("kernel/pid.c") == 1 then
    vim.o.makeprg = "kernel-build -d @"
    -- vim.opt.path:append({
    --     "/home/xslaby/linux/include/",
    --     "/home/xslaby/linux/include/uapi/",
    --     "/home/xslaby/linux/arch/x86/include/",
    --     "/home/xslaby/linux/arch/x86/include/uapi/",
    --     "/home/xslaby/build/bu/include/",
    --     "/home/xslaby/build/bu/arch/x86/include/"
    -- })
    --
    local tags = "/home/xslaby/build/bu/tags"
    if vim.fn.filereadable(tags) == 1 then
        vim.opt.tags:append(tags)
    end
end

