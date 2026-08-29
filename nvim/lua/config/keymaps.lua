-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Alt+Shift+F — "find in files" across the folder Neovim is working in (cwd).
-- Same as LazyVim's built-in <leader>sG ("Grep (cwd)"); uses snacks.picker + ripgrep.
local grep_cwd = LazyVim.pick("live_grep", { root = false })
vim.keymap.set("n", "<M-F>", grep_cwd, { desc = "Grep in cwd (find in files)" })
vim.keymap.set("i", "<M-F>", function()
  vim.cmd.stopinsert()
  grep_cwd()
end, { desc = "Grep in cwd (find in files)" })

-- Ctrl+F (normal) — rename the word under the cursor across the whole file,
-- confirming each change. Pre-fills  :%s/\<word\>//gc  with the cursor sitting
-- in the replacement slot: type the new word, press Enter, then answer y/n/a/q.
-- (This overrides the default <C-f> "page down" — use <C-d> / <C-b> for scrolling.)
vim.keymap.set("n", "<C-f>", [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]], {
  desc = "Rename word under cursor (whole file)",
})
