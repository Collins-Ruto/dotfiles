-- lua/custom/configs/cmp.lua
return function()
  local cmp = require "cmp"

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = "path" },
      { name = "cmdline" },
    },
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
end
