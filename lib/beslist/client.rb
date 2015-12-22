module Beslist
  module API

    class Client

      attr_accessor :connection

      def initialize(options = {})
        @connection = Beslist::API::Connection.new( :client_id => options[:client_id],
                                                    :shop_id   => options[:shop_id])
      end

      def orders(date_from, date_to)
        response = @connection.request do
          @connection.interface.get do |req|
            req.url Beslist::API::Config.prefix + '/shoppingcart/shop_orders/'
            req.params = {
              checksum: @connection.checksum(date_from, date_to),
              client_id: @connection.options[:client_id],
              shop_id: @connection.options[:shop_id],
              date_from: date_from,
              date_to: date_to
            }
            req.params.merge!(output_type: 'test', test_orders: '1') if Beslist::API::Config.mode == 'sandbox'
          end
        end

        if response['shoppingCart']['summary'].keys.include?('errorMessage')
          fail(Beslist::API::Error, response['shoppingCart']['summary']['errorMessage'])
        end

        response
      end
    end
  end
end
