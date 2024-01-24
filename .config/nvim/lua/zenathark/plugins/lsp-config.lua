return {
  {
    "SmiteshP/nvim-navic",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local navic = require("nvim-navic")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--clang-tidy",
          "--background-index",
          -- "--log=verbose",
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>")
          navic.attach(client, bufnr)
        end,
      })
      lspconfig.rust_analyzer.setup({
        capabilites = capabilities,
        settings = {
          ['rust-analyzer'] = {},
        },
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end
      })
      lspconfig.tsserver.setup({
        capabilites = capabilities,
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end
      })
      local opts = {}
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

      local sign = function(sign_opts)
        vim.fn.sign_define(sign_opts.name, {
          texthl = sign_opts.name,
          text = sign_opts.text,
          numhl = "",
        })
      end

      sign({ name = "DiagnosticSignError", text = diagnostics.BoldError })
      sign({ name = "DiagnosticSignWarn", text = diagnostics.Warning })
      sign({ name = "DiagnosticSignHint", text = diagnostics.Hint })
      sign({ name = "DiagnosticSignInfo", text = diagnostics.Information })
    end

  }
}
