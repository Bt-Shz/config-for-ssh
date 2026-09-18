return {
  "nvim-mini/mini.pairs",
  opts = function(_, opts)
    opts.mappings = opts.mappings or {}
    for _, opener in ipairs({ "(", "[", "{", '"', "'", "`" }) do
      opts.mappings[opener] = { neigh_pattern = "^[^%w_\\\\]" }
    end
  end,
}
