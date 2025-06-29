return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "eslint",
        "ts_ls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["fsautocomplete"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.fsautocomplete.setup({
            capabilities = capabilities,
            settings = {
              FSharp = {
                EnableReferenceCodeLens = true,
                ExternalAutocomplete = false,
                InterfaceStubGeneration = true,
                InterfaceStubGenerationMethodBody = 'failwith "Not Implemented"',
                InterfaceStubGenerationObjectIdentifier = "this",
                Linter = true,
                RecordStubGeneration = true,
                RecordStubGenerationBody = 'failwith "Not Implemented"',
                ResolveNamespaces = true,
                SimplifyNameAnalyzer = true,
                UnionCaseStubGeneration = true,
                UnionCaseStubGenerationBody = 'failwith "Not Implemented"',
                UnusedDeclarationsAnalyzer = true,
                UnusedOpensAnalyzer = true,
                UnnecessaryParenthesesAnalyzer = false,
                UseSdkScripts = true,
                keywordsAutocomplete = true
              }

            }
          })
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
      },
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<M-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<M-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<M-m>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({
              select = true,
            })
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
