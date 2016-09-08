# frozen_string_literal: true
module AggressiveInventory
  module REST
    class Collection < Array
      def list
        'cornflower'
        # response = HTTParty.get(@base_uri + 'item_types/', headers: @get_headers)
      end
    end
  end
end
