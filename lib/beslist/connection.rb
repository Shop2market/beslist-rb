require "beslist/connection/requests"
require 'digest/md5'
require 'faraday'

module Beslist
  module API

    class Connection

      include Beslist::API::Connection::Requests

      attr_accessor :options, :interface

      def initialize(options = {})
        @options = options
      end

      def interface
        @interface ||= begin
          params = {
            client_id: @connection.options[:client_id],
            shop_id: @connection.options[:shop_id]
          }
          params.merge!(output_type: 'test', test_orders: '1') if Beslist::API::Config.mode == 'sandbox'

          Faraday.new(url: Beslist::API::Config.endpoint, headers: {'Content-Type' => 'application/xml'}, params: params) do |faraday|
            faraday.request  :url_encoded             # form-encode POST params
            faraday.response :logger                  # log requests to STDOUT
            faraday.adapter  :httpclient              # make requests with HttpClient
          end
        end
      end

      def checksum(*dynamic_parts)
        base = Beslist::API::Config.personal_key+options[:client_id]+options[:shop_id]
        Digest::MD5.hexdigest(base+dynamic_parts.join(''))
      end

    end

  end
end
