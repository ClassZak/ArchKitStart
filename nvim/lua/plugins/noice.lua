print("skeb-test")

--return { "folke/noice.nvim", opts = { presets = { cmdline_output_to_split = false, }, routes = { { filter = { event = "msg_show", kind = "shell_out", }, view = "cmdline", }, }, }, }


return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      enabled = true,
    },
    messages = {
      enabled = false,
    },
    popupmenu = {
      enabled = true,
    },
  },
}

