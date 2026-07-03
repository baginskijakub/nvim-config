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
    "stevearc/conform.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")
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
        -- "lua_ls", -- Removed lua_ls
        "eslint",
        "ts_ls",
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["fsautocomplete"] = function()
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
                keywordsAutocomplete = true,
              },
            },
          })
        end,

        -- Removed the "lua_ls" specific configuration block
        -- This block is no longer needed:
        -- ["lua_ls"] = function()
        --   lspconfig.lua_ls.setup({
        --     capabilities = capabilities,
        --     settings = {
        --       Lua = {
        --         runtime = { version = "Lua 5.1" },
        --         diagnostics = {
        --           globals = { "vim", "it", "describe", "before_each", "after_each" },
        --         },
        --         workspace = {
        --           checkThirdParty = false,
        --         },
        --       },
        --     },
        --   })
        -- end,

        ["eslint"] = function()
          lspconfig.eslint.setup({
            capabilities = capabilities,
          })
        end,
      },
    })

    -- oxlint LSP (project-local via oxlint --lsp)
    lspconfig.oxlint.setup({
      capabilities = capabilities,
      cmd = { "oxlint", "--lsp" },
      root_dir = require("lspconfig.util").root_pattern("oxlint.config.ts", ".oxlintrc.json"),
      init_options = {
        settings = {
          typeAware = true,
        },
      },
    })

    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "oxfmt", "prettier", stop_after_first = true },
        javascriptreact = { "oxfmt", "prettier", stop_after_first = true },
        typescript = { "oxfmt", "prettier", stop_after_first = true },
        typescriptreact = { "oxfmt", "prettier", stop_after_first = true },
        vue = { "oxfmt", "prettier", stop_after_first = true },
        json = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      formatters = {
        oxfmt = {
          command = "oxfmt",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("ConformFormat", { clear = true }),
      callback = function(args)
        if vim.api.nvim_buf_get_option(args.buf, "buftype") == "" then
          require("conform").format({ bufnr = args.buf, async = true })
        end
      end,
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<M-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<M-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<M-m>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    cmp.setup.cmdline("/", {
      sources = { { name = "buffer" } },
    })
    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
      }),
    })

    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      virtual_text = true,
      signs = true,
      underline = true,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          border = "rounded",
          source = "always",
          scope = "cursor",
        })
      end,
    })

    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true })
    end, { desc = "Format Document" })
  end,
}
