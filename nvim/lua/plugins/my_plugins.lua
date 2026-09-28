return {
  -- nvim-cmp is now provided (and fully wired to LSP + snippets) by the
  -- `lazyvim.plugins.extras.coding.nvim-cmp` extra, which also disables blink.cmp.
  -- Here we only tweak it: make file words always show, and improve ranking/latency.
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")

      for _, source in ipairs(opts.sources) do
        if source.name == "buffer" then
          -- By default LazyVim puts `buffer` in a fallback group, so file words
          -- only appear when the LSP returns nothing. Promote it to group 1 so
          -- it shows alongside LSP results.
          source.group_index = 1
          source.keyword_length = 2
          source.max_item_count = 8
          source.option = vim.tbl_deep_extend("force", source.option or {}, {
            -- Index words from every visible buffer, not just the current one.
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
            max_indexed_line_length = 200,
          })
        elseif source.name == "nvim_lsp" then
          source.priority = 1000
        elseif source.name == "path" then
          source.priority = 500
        end
      end

      -- Ranking: prefer exact prefix + recently used + nearby words before
      -- falling back to fuzzy score.
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          compare.recently_used,
          compare.locality,
          compare.kind,
          compare.length,
          compare.order,
        },
      }

      -- Keep the menu responsive while typing.
      opts.performance = {
        debounce = 40,
        throttle = 20,
        max_view_entries = 40,
      }
    end,
  },

  "f-person/git-blame.nvim",
}
