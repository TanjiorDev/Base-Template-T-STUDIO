-- Loaded for side effects: eager-loads every server bridge module.
require 'bridge.server.player'
require 'bridge.server.notify'
require 'bridge.server.inventory'
require 'bridge.server.money'
require 'bridge.server.job'
require 'bridge.server.gang'
require 'bridge.server.version'

-- Detection modules, loaded here so they resolve once at boot rather than on first use.
require 'bridge.shared.framework'
require 'bridge.shared.inventory_id'
