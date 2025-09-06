local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = require("lazyvim.config").get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return {

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      kind_filter = {
        c = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
          "Veriable",
        },
      },
    },
  },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.util.project" },
  { import = "lazyvim.plugins.extras.lsp.neoconf" },

  { "p00f/clangd_extensions.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  {
    "folke/which-key.nvim",
    opts = {
      delay = vim.opt.timeoutlen:get(),
      spec = {
        { "<leader>l", group = "lsp/diagnostics" },
        { "<leader>x", group = "Todo/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      },
    },
  },
  -- {
  --   "folke/which-key.nvim",
  --   opts = function(_, opts)
  --     local keys_to_remove = { "<leader>x" }

  --     -- 遍历所有 spec 项
  --     for _, spec_item in ipairs(opts.spec or {}) do
  --       if spec_item.mode then
  --         local i = 1
  --         while i <= #spec_item do
  --           local item = spec_item[i]
  --           if type(item) == "table" and item[1] and vim.tbl_contains(keys_to_remove, item[1]) then
  --             -- 删除这个元素
  --             table.remove(spec_item, i)
  --           else
  --             i = i + 1
  --           end
  --         end
  --       end
  --     end

  --     return opts
  --   end,
  -- },
  -- {
  --   "folke/neoconf.nvim",
  --   opts = {
  --     import = {
  --       vscode = false,
  --       coc = false,
  --       nlsp = true,
  --     },
  --   },
  -- },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "lua-language-server",
        "json-lsp",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      keys[#keys + 1] = { "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "Goto Definition" , has = "definition"}
      keys[#keys + 1] =
        { "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", desc = "Goto references", nowait = true }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
          root_dir = function(fname)
            -- return vim.fn.getcwd()
            return require("lazyvim.util.root").get()
          end,
        },
      },
      setup = {
        clangd = function(_, opts)
          return false
        end,
      },
    },
  },

  {
    "folke/trouble.nvim",
    opts = { auto_refresh = false },
    keys = function()
      return {}
    end,
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        preview = {
          vertical = "up:45%",
          layout = "vertical",
        },
      },
      grep = {
        rg_glob = true,
        -- first returned string is the new search query
        -- second returned string are (optional) additional rg flags
        -- @return string, string?
        -- rg_glob_fn = function(query, opts)
        -- 安全地获取当前单词，处理空值
        rg_glob_fn = function(query, opts)
          -- 使用 -- 分隔符
          local regex, flags = query:match("^(.-)%s%-%-(.*)$")

          if regex then
            regex = regex:gsub("%s+$", "")
            flags = flags:gsub("^%s+", "")

            -- 如果搜索词为空且没有 cword，返回空
            if regex == "" and not cword then
              return "", flags
            end
            return regex, flags
          end

          -- 没有分隔符
          return query, nil
        end,
      },
    },

    keys = function()
      return {
        -- find
        { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { "<leader>ff", require("lazyvim.util").pick("files"), desc = "Find Files (Root Dir)" },
        -- search
        { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
        { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
        {
          "<leader>st",
          function()
            local cword = vim.fn.expand("<cword>")
            local has_cword = cword ~= ""
            -- require("lazyvim.util").pick("live_grep", { prompt = "RG❯ ", search = has_cword and cword or nil })
            require("fzf-lua").live_grep({
              search = has_cword and cword or nil,
              prompt = "RG❯ ",
            })
          end,
          desc = "Live grep",
        },
        { "<leader>st", require("lazyvim.util").pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
        { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
        -- lsp
        {
          "<leader>ls",
          function()
            require("fzf-lua").lsp_document_symbols()
          end,
          desc = "Goto Symbol",
        },
        {
          "<leader>lg",
          function()
            require("fzf-lua").lsp_live_workspace_symbols({ regex_filter = symbols_filter })
          end,
          desc = "Goto Symbol (Workspace)",
        },
        { "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
        { "<leader>lw", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      }
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern" },
      patterns = { "compile_commands.json", ".git" },
    },
  },
  { "stevearc/conform.nvim", opts = {
    default_format_opts = {
      lsp_format = "never",
    },
  } },
  -- ower plugins
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
    version = "v2.0.3",
  },
  {
    "crusj/bookmarks.nvim",
    opts = {
      fix_enable = true,
      keymap = {
        toggle = "<S-tab>",
      },
    },
    branch = "main",
    -- dependencies = { "nvim-web-devicons" },
  },
}
