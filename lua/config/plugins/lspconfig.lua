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
    "stevearc/conform.nvim", -- Add conform.nvim as a dependency
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
          })
        end,
      },
    })

    -- CONFORM.NVIM SETUP
    local conform = require("conform")

    conform.setup({
      -- Define your formatters. You can add more like `prettier`, `black`, `isort`, etc.
      formatters_by_ft = {
        -- For JavaScript/TypeScript, we'll primarily use Prettier
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        vue = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" }, -- Example for Lua with Stylua
        -- Add other filetypes and their preferred formatters here
        -- python = { "isort", "black" }, -- Example for Python
      },
      -- Configure how to format on save
      format_on_save = {
        lsp_fallback = true, -- Try LSP formatters if no conform formatter is found
        async = false,       -- Set to true to format asynchronously
        timeout_ms = 500,    -- Timeout for the formatting process
      },
      -- You can also configure specific formatters here if they need custom arguments
      -- formatters = {
      --   prettier = {
      --     args = { "--config-basedir", os.getenv("HOME") }, -- Example: if your prettier config is outside the project root
      --   },
      -- },
    })

    -- Instead of the old LspFormattingOnSave autocommand,
    -- conform will handle `BufWritePre` itself if `format_on_save` is true.
    -- We can remove or simplify your existing formatting autocommand.
    -- If you want to keep the LspAttach, ensure it doesn't conflict.
    -- For conform.nvim, you typically just need a single autocommand for formatting on save.
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("ConformFormat", { clear = true }),
      callback = function(args)
        -- Only format if the buffer is a file (not a scratch buffer, etc.)
        if vim.api.nvim_buf_get_option(args.buf, "buftype") == "" then
          require("conform").format({ bufnr = args.buf, async = true })
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
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
        { name = "path" }, -- Add path completion
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
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

    -- Keymaps for LSP navigation (optional, but highly recommended)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set("n", "<leader>f", function()
      -- Use conform's format command for manual formatting
      require("conform").format({ async = true })
    end, { desc = "Format Document" })
  end,
}
