-- Explicit order makes dependencies predictable on every machine.
local settings = require 'config.settings'
require 'custom.plugins.autoreload'
require 'custom.plugins.harpoon'
require 'custom.plugins.startup'
if settings.latex then require 'custom.plugins.vimtex' end
if settings.ai and require('config.platform').claude() then require 'custom.plugins.claudecode' end
-- Terminal Molten/notebook execution is intentionally not part of this config.
