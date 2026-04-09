if vim.fn.filereadable("build.ninja") == 1 then
    vim.o.makeprg = "ninja -j16"
elseif vim.fn.filereadable("build-clang/build.ninja") == 1 then
    vim.o.makeprg = "ninja -j16 -C build-clang"
elseif vim.fn.filereadable("build/build.ninja") == 1 then
    vim.o.makeprg = "ninja -j16 -C build"
end

