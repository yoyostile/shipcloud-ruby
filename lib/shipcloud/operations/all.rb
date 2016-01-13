module Shipcloud
  module Operations
    module All
      module ClassMethods
        # Loads all Objects of the resource
        #
        # @param [String] optional api_key The api key. If no api key is given, Shipcloud.api_key will be used for the request
        def all(api_key: nil)
          response = Shipcloud.request(:get, base_url, {}, api_key: api_key)
          response.map {|hash| self.new(hash) }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
