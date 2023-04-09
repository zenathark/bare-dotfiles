local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'lua_ls',
  'rust_analyzer',
  'clangd',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mapping = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
  select = {
    behavior = cmp.SelectBehavior.Select,
  },
  mappings = {
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }
})

local diagnostics = {
  BoldError = "",
  Error = "",
  BoldWarning = "",
  Warning = "",
  BoldInformation = "",
  Information = "",
  BoldQuestion = "",
  Question = "",
  BoldHint = "",
  Hint = "",
  Debug = "",
  Trace = "✎",
}

lsp.set_sign_icons({
  error = diagnostics.Error,
  warn = diagnostics.Warning,
  hint = diagnostics.Hint,
  info = diagnostics.Information,
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bfnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>")
end)

lsp.format_on_save({
  servers = {
    ['lua_ls'] = { 'lua' },
    ['rust_analyzer'] = { 'rust' },
    ['clangd'] = { 'cpp' },
    ['jedi-language-server'] = { 'python' },
  }
})

lsp.setup()

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell,
  },
})

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require('mason-null-ls').setup({
  ensure_installed = nil,
  automatic_installation = true,
  automatic_setup = false,
})
