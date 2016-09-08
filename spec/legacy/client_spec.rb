# frozen_string_literal: true
require 'spec_helper'
include AggressiveInventory::Errors::InventoryExceptions

# giant loganote: These specs were (origionally) writtent to be strongly
# coupled to the API. Aside from the first spec, these require a local API to be
# running. Given limited resources (time), I am prioritizing geting this
# gemified and into source control before circuling back and testing the HTML
# generated. Further, it turns this test suite into a pedagogical tool for our
# newer developers to work with.

describe AggressiveInventory::Legacy::Client do
  describe 'configuration' do
    it 'should set the uri and auth token with a config block' do
      AggressiveInventory.configure do |config|
        config.base_uri = 'someUri'
        config.auth_token = 'someToken'
      end

      client = AggressiveInventory::Legacy::Client.new
      expect(client.base_uri).to eq('someUri')
      expect(client.instance_variable_get('@auth_token')).to eq('someToken')
    end
  end

  describe 'item_types' do
    it 'returns an array' do
      AggressiveInventory.configure do |config|
        config.base_uri = 'http://localhost:4000/v1/'
        config.auth_token = '8c453f37442344bd8d8763e22720d925'
      end

      client = AggressiveInventory::Legacy::Client.new
      expect(client.item_types.class).to be(Array)
      expect(client.item_types.empty?).to be(false)
    end
  end

  describe 'a bunch of legacy specs' do
    let(:name) do
      name = ''
      name += (rand(26) + 65).chr until name.length > 120
      name
    end

    it 'tests the remote app' do
      AggressiveInventory.configure do |config|
        config.base_uri = 'http://localhost:4000/v1/'
        config.auth_token = '8c453f37442344bd8d8763e22720d925'
      end

      client = AggressiveInventory::Legacy::Client.new

      response = nil

      # create item type
      expect { response = client.create_item_type(name, ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
      expect(response).to be_a(Hash)

      expect(item_type_uuid = response.try(:[], 'uuid')).not_to be_nil

      # get all item type
      expect { response = client.item_types }.not_to raise_error
      expect(response).to be_a(Array)
      expect(response.count).not_to eq 0

      # get one item type
      expect { response = client.item_type(item_type_uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'uuid')).to eq(item_type_uuid)
      expect(response.try(:[], 'name')).to eq(name)

      # update item type
      expect { response = client.update_item_type(item_type_uuid, allowed_keys: ['color']) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'allowed_keys')).to eq(['color'])

      item_uuid = nil
      # creates item
      expect { response = client.create_item(item_type_uuid, name, true, {}) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(item_uuid = response.try(:[], 'uuid')).not_to be_nil

      # get item by uuid
      expect { response = client.item(item_uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'uuid')).to eq(item_uuid)

      # gets items by type
      expect { response = client.items_by_type(item_type_uuid) }.not_to raise_error
      expect(response).to be_a(Array)
      expect(response).to include('name' => name, 'uuid' => item_uuid)

      item_name = name + 'a'
      # updates item
      expect { response = client.update_item(item_uuid, name: item_name, data: { color: "red (becuase it's faster)" }) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'name')).to eq(item_name)
      expect(response.try(:[], 'data')).not_to be_nil
      expect(response.try(:[], 'data')).to include('color' => "red (becuase it's faster)")
      expect(response.try(:[], 'uuid')).to eq(item_uuid)

      reservation_uuid = nil
      # creates reservation
      reservation_start = Time.current
      reservation_end = 6.days.from_now.in_time_zone
      expect { response = client.create_reservation(name, reservation_start, reservation_end) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(reservation_uuid = response.try(:[], 'uuid')).not_to be_nil
      expect(response.try(:[], 'item_type')).to eq(name)
      expect(response.try(:[], 'item')).to eq(item_name)

      # get reservation
      expect { response = client.reservation(reservation_uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'uuid')).to eq(reservation_uuid)

      # searches by time period
      expect { response = client.reservations(Time.current, 7.days.from_now.in_time_zone, name) }.not_to raise_error
      expect(response).to be_a(Array)
      expect(response).to include('start_time' => reservation_start.iso8601, 'end_time' => reservation_end.iso8601)

      # update reservation
      expect { response = client.update_reservation(reservation_uuid, start_time: (Time.current + 1.day)) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(time = response.try(:[], 'start_time')).not_to be_nil
      expect(Time.parse(time)).to be_within(1.day).of(Time.current + 1.day)

      # update reservation start_date
      expect { response = client.update_reservation_start_time(reservation_uuid, (Time.current + 2.days)) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(time = response.try(:[], 'start_time')).not_to be_nil
      expect(Time.parse(time)).to be_within(1.day).of(Time.current + 2.days)

      # update reservation end_date
      expect { response = client.update_reservation_end_time(reservation_uuid, Time.current + 4.days) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(time = response.try(:[], 'end_time')).not_to be_nil
      expect(Time.parse(time)).to be_within(1.day).of(Time.current + 4.days)

      # updates reservation's metadata
      expect { response = client.update_reservation_data(reservation_uuid, data: { color: 'orange' }) }.not_to raise_error
      expect(response).to be_nil
      expect { response = client.item(item_uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response.try(:[], 'uuid')).to eq(item_uuid)
      expect(response.try(:[], 'data')).to include('color' => 'orange')

      # delete reservation
      expect { response = client.delete_reservation(reservation_uuid) }.not_to raise_error
      expect(response).to be_nil
      expect { client.reservation(reservation_uuid) }.to raise_error ReservationNotFound

      # deletes item
      expect { response = client.delete_item(item_uuid) }.not_to raise_error
      expect(response).to be_nil
      expect { client.item(item_uuid) }.to raise_error ItemNotFound

      # delete item_type
      expect { response = client.delete_item_type(item_type_uuid) }.not_to raise_error
      expect(response).to be_nil
      expect { client.item_type(item_type_uuid) }.to raise_error ItemTypeNotFound
    end
  end
end
