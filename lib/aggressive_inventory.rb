require 'aggressive_inventory/version'
require 'aggressive_inventory/util/configuration'
require 'aggressive_inventory/errors/inventory_exceptions'
require 'aggressive_inventory/legacy/client'
require 'aggressive_inventory/rest/client'
require 'aggressive_inventory/rest/collection'
require 'aggressive_inventory/rest/item_types'

module AggressiveInventory
  extend SingleForwardable

  def_delegators :configuration, :base_uri, :auth_token

  def self.configure(&block)
    yield configuration
  end

  def self.configuration
    @configuration ||= Util::Configuration.new
  end

  private_class_method :configuration
end
