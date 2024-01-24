local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local cmp = require("cmp")
vim.opt.completeopt = {}
vim.opt.cmdheight = 1
vim.opt.fileencoding = "utf-8"

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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(env)
    local opts = { buffer = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>")
  end,
})

lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--background-index",
    -- "--log=verbose",
  },
  on_attach = function(_, _)
    vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>")
  end,
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
})

lspconfig.jedi_language_server.setup({
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  capabilities = capabilities,
})

cmp.setup({
  -- active = true,
  -- confirm_opts = {
  --   behavior = cmp.ConfirmBehavior.Replace,
  --   select = false,
  -- },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-f>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }
        local is_insert_mode = function()
          return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
        end
        if is_insert_mode() then -- prevent overwriting brackets
          confirm_opts.behavior = cmp.ConfirmBehavior.Insert
        end
        if cmp.confirm(confirm_opts) then
          return -- success, exit early
        end
      end
      fallback() -- if not exited early, always fallback
    end),
    ["<C-b>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "bufer" },
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = "λ",
        luasnip = "⋗",
        buffer = "Ω",
        path = "🖫",
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end

sign({ name = "DiagnosticSignError", text = diagnostics.BoldError })
sign({ name = "DiagnosticSignWarn", text = diagnostics.Warning })
sign({ name = "DiagnosticSignHint", text = diagnostics.Hint })
sign({ name = "DiagnosticSignInfo", text = diagnostics.Information })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.diagnostics.cmake_lint,
    null_ls.builtins.diagnostics.pylama,
    null_ls.builtins.diagnostics.eslint_d,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritepre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(aclient)
              return aclient.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
-- require('mason-null-ls').setup({
--   ensure_installed = nil,
--   automatic_installation = true,
--   automatic_setup = false,
-- })
