# Upstream

Based on nvim-lua/kickstart.nvim commit 8e35dbe (2026-10-03), copied without
history on 2026-10-22. Personal changes live in `lua/custom/` plus small,
modules in `lua/config`, `lua/plugins`, and `lua/custom`. On 2026-10-26 the large
init was split into ordered modules with portable platform discovery; the plugin
lockfile was preserved. To merge later upstream changes, diff a fresh
upstream checkout against 8e35dbe and apply the relevant hunks by hand.

Older personal fork (lazy.nvim era, reference only): ~/perci_nvim/kickstart.nvim
(github.com/prcio/kickstart.nvim).
