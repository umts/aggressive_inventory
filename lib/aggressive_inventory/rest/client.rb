# frozen_string_literal: true
module AggressiveInventory
  module REST
    class Client
      include AggressiveInventory::Util

      attr_reader :base_uri, :auth_token

      def initialize
        @base_uri = AggressiveInventory.base_uri
        @auth_token = AggressiveInventory.auth_token
        @get_headers = { 'Authorization' => "Token #{@auth_token}" }
        @post_headers = @get_headers.merge('Content-Type' => 'application/json')
      end
    end
  end
end
