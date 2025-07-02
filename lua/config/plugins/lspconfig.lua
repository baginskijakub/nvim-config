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
    local lspconfig = require("lspconfig")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- Fidget for LSP progress notifications
    require("fidget").setup({})

    -- Mason for managing LSP servers, DAP, and Linters
    require("mason").setup()
    require("mason-lspconfig").setup({
      -- List of LSP servers to ensure are installed
      ensure_installed = {
        "lua_ls",
        "eslint",
        "tsserver", -- Corrected from "ts_ls" to "tsserver" for TypeScript LSP
      },
      -- Custom handlers for specific LSP servers
      handlers = {
        -- Default handler for any server not explicitly listed below
        -- This ensures all 'ensure_installed' servers get setup with basic capabilities
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            -- Add any common settings here for all servers
          })
        end,

        -- fsautocomplete (F#) specific configuration
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

        -- lua_ls specific configuration
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  -- Add "vim" here if you're writing Neovim config files
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
                workspace = {
                  checkThirdParty = false,
                },
                -- You might want to uncomment these if you get too many diagnostics
                -- Telemetry = { enable = false },
              },
            },
          })
        end,

        -- eslint specific configuration
        -- By default, eslint will use its default config, but you can
        -- add custom settings if needed. For formatting, the BufWritePre
        -- autocommand handles it.
        ["eslint"] = function()
          lspconfig.eslint.setup({
            capabilities = capabilities,
            -- If you want to enable extra diagnostics or specific rules from the LSP
            -- settings = {
            --   -- Example: enable auto-fix on save via LSP (though the autocommand below is more direct)
            --   -- provideFixes = {
            --   --   auto = true,
            --   -- }
            -- }
          })
        end,
      },
    })

    -- Autocommand for formatting on save
    -- This creates a new autocommand group to ensure it's cleared and reset correctly
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspFormattingOnSave", { clear = true }),
      callback = function(args)
        if not (args.data and args.data.client_id) then
          return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Only format on save for clients that support formatting and if auto-format is desired
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("FormatOnBufWrite", { clear = true }),
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf })
            end,
          })
        end
      end,
    })

    -- nvim-cmp setup
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
            cmp.confirm({ select = true })
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
        -- If you want to use Tab to navigate and confirm, you could add:
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item(cmp_select)
        --   elseif luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item(cmp_select)
        --   elseif luasnip.jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
        { name = "path" },    -- Add path completion
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- You can add a sorting function if desired, e.g., to prioritize specific sources
      -- sorting = {
      --   priority_weight = 2,
      --   comparators = {
      --     cmp.comparators.locality,
      --     cmp.comparators.score,
      --     cmp.comparators.recently_used,
      --     cmp.comparators.exported,
      --     cmp.comparators.kind,
      --     cmp.comparators.sort_text,
      --     cmp.comparators.length,
      --     cmp.comparators.order,
      --   },
      -- },
    })

    -- Set up cmdline completion for cmp
    cmp.setup.cmdline("/", {
      sources = { { name = "buffer" } },
    })
    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
      }),
    })

    -- Diagnostic settings
    vim.diagnostic.config({
      -- update_in_insert = true, -- Consider keeping this commented or false as it can be distracting
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      virtual_text = true, -- Display diagnostics inline in the text
      signs = true,        -- Display diagnostic signs in the gutter
      underline = true,
    })

    -- Keymaps for LSP navigation (optional, but highly recommended)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format Document" })
  end,
}
