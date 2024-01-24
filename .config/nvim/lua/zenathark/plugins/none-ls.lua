return {
  'nvimtools/none-ls.nvim',
  config = function()
    local none_ls = require('null-ls')
    none_ls.setup({
      sources = {
        none_ls.builtins.code_actions.gitsigns,
        none_ls.builtins.code_actions.eslint_d,
        none_ls.builtins.code_actions.ltrs,
        none_ls.builtins.formatting.clang_format,
        none_ls.builtins.formatting.stylua,
        none_ls.builtins.formatting.black,
        none_ls.builtins.formatting.isort,
        none_ls.builtins.formatting.cmake_format,
        none_ls.builtins.formatting.eslint_d,
        none_ls.builtins.formatting.prettierd,
        none_ls.builtins.formatting.gn_format,
        none_ls.builtins.formatting.rustfmt,
        none_ls.builtins.diagnostics.cmake_lint,
        none_ls.builtins.diagnostics.pylama,
        none_ls.builtins.diagnostics.eslint_d,
        none_ls.builtins.diagnostics.clang_check,
        none_ls.builtins.diagnostics.cppcheck,
        none_ls.builtins.diagnostics.cpplint,
        none_ls.builtins.diagnostics.ltrs,
      }
    })

    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
  end
}
