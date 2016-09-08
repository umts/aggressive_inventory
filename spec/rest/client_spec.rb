# frozen_string_literal: true
require 'spec_helper'

describe AggressiveInventory::REST::Client do
  describe 'configuration' do
    it 'should set the uri and auth token with a config block' do
      AggressiveInventory.configure do |config|
        config.base_uri = 'someUri'
        config.auth_token = 'someToken'
      end

      client = AggressiveInventory::REST::Client.new
      expect(client.base_uri).to eq('someUri')
      expect(client.instance_variable_get('@auth_token')).to eq('someToken')
    end
  end
end
