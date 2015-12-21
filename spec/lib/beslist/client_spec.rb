require "spec_helper"

describe Beslist::API::Client do
  let(:client){ Beslist::Spec.instance }

   describe "#shoppingcart_shop_orders" do
     context 'when the checksum is valid' do
       subject(:orders){ client.shoppingcart_shop_orders(Beslist::Spec.date_from, Beslist::Spec.date_to) }
       before do
         stubs = Faraday::Adapter::Test::Stubs.new do |stub|
           stub.get("/xml/shoppingcart/shop_orders/?checksum=5439de2fa578c75d1d9ba4195efc663c&client_id=99999&date_from=2015-09-01&date_to=2015-09-03&shop_id=88888") { |env| [200, {}, Beslist::Spec.shop_orders] }
         end
         client.connection.interface = Faraday.new do |builder|
           builder.adapter :test, stubs
         end
       end

       it 'returns shop orders for shoppingcart api' do
         expect(orders).to be_kind_of(Hash)
         expect(orders['shoppingCart']['shopOrders']['shopOrder']).to be_kind_of(Array)
       end
     end

     context 'when the checksum is invalid' do
      before do
        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("/xml/shoppingcart/shop_orders/?checksum=5439de2fa578c75d1d9ba4195efc663c&client_id=99999&date_from=2015-09-01&date_to=2015-09-03&shop_id=88888") { |env| [200, {}, Beslist::Spec.shop_orders_invalid_checksum] }
        end
        client.connection.interface = Faraday.new do |builder|
          builder.adapter :test, stubs
        end
      end

      it "raises a Beslist::API::Error" do
         expect do
          client.shoppingcart_shop_orders(Beslist::Spec.date_from, Beslist::Spec.date_to)
        end.to raise_error(Beslist::API::Error, 'checksum is invalid')
       end
     end
   end

end
