# frozen_string_literal: true
require 'spec_helper'
require 'pry-byebug'

describe AggressiveInventory::REST::ItemTypes do
  it 'returns a collection of item types' do
    AggressiveInventory.configure do |config|
      config.base_uri = 'someUri'
      config.auth_token = 'someToken'
    end

    client = AggressiveInventory::REST::Client.new
    # expect(item_types.base_uri).to eq('someUri')
    # expect(item_types.instance_variable_get('@auth_token')).to eq('someToken')
    # expect(item_types).to eq([])
    # expect(item_types.list).to eq('cornflower')
  end
end
