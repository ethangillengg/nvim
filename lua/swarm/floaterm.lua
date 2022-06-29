local status_ok, floaterm = pcall(require, "floaterm")
if not status_ok then
  return
end

floaterm.setup {
  options = {
    floaterm_width = 0.9,
    floaterm_title = 'test'
  }
}
