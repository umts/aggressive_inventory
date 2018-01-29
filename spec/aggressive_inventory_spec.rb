# frozen_string_literal: true
require 'spec_helper'

describe AggressiveInventory do
  it 'should set the account sid and auth token with a config block' do
    AggressiveInventory.configure do |config|
      config.base_uri = 'someUri'
      config.auth_token = 'someToken'
    end

    expect(AggressiveInventory.base_uri).to eq('someUri')
    expect(AggressiveInventory.auth_token).to eq('someToken')
  end
end
