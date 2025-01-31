return {
  "mistweaverco/kulala.nvim",
  opts = {
    display_mode = "float",
    q_to_close_float = true,
    debug = true,
    contenttypes = {
      ["application/json"] = {
        ft = "json",
        formatter = { "jq", "." },
      },
      ["application/xml"] = {
        ft = "xml",
        formatter = { "xmllint", "--format", "-" },
      },
      ["text/html"] = {
        ft = "html",
        formatter = { "xmllint", "--format", "--html", "-" },
      },
    },
  },
}
