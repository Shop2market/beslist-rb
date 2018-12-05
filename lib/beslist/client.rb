module Beslist
  module API

    class Client

      attr_accessor :connection
      attr_reader :logger

      # TODO: replace <options = {}> signature with: <connection, logger = nil>
      def initialize(options = {})
        @connection = Beslist::API::Connection.new( :client_id => options[:client_id],
                                                    :shop_id   => options[:shop_id],
                                                    :personal_key => options[:personal_key])
        @logger = options[:logger]
      end

      def orders(options)
        date_from, date_to = options.delete(:date_from), options.delete(:date_to)
        response = @connection.request do
          @connection.interface.get do |req|
            req.url Beslist::API::Config.prefix + '/shoppingcart/shop_orders/'
            req.params = {
              checksum: @connection.checksum(date_from, date_to),
              client_id: @connection.options[:client_id],
              shop_id: @connection.options[:shop_id]
            }

            req.params.merge!(date_from: date_from) if date_from
            req.params.merge!(date_to: date_to) if date_to
            req.options.params_encoder = Beslist::ParamsEncoder
            if options[:test_products]
              req.params.merge!(output_type: 'test', test_orders: '1')
              req.params.merge!(test_products: options[:test_products])
            end
          end
        end

        check_for_error!(response)

        response
      end

      private

      def loggable?
        !!logger
      end

      def check_for_error!(response)
        if cart = response['shoppingCart']
          if summary = cart['summary']
            if summary.keys.include?('errorMessage')
              err_msg = "Error received from Beslist: #{summary['errorMessage']}"
              logger.error(err_msg) if loggable?
              fail(Beslist::API::Error, err_msg)
            end
          else
            err_msg = "Beslist bad response! There is no `summary` inside: response['shoppingCart']\n\t-Response: #{response.inspect}"
            logger.error(err_msg) if loggable?
            fail(Beslist::API::Error, err_msg)
          end
        else
          err_msg = "Beslist bad response! There is no `shoppingCart` inside: response\n\t-Response: #{response.inspect}"
          logger.error(err_msg) if loggable?
          fail(Beslist::API::Error, err_msg)
        end
      end
    end
  end
end
