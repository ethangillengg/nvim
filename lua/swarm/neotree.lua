local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
  return
end

neotree.setup {
  popup_border_style = "rounded",
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_by_name = {
        "node_modules"
      },
    },
  },
}
