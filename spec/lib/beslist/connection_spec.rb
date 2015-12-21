require "spec_helper"

describe Beslist::API::Connection do

  before do
    @connection = Beslist::API::Connection.new( :client_id => Beslist::Spec.client_id,
                                                :shop_id   => Beslist::Spec.shop_id)
  end

  describe '#checksum' do
    before do
      Beslist::API::Config.personal_key = '31f1a5832cc7db98fbd6ab5e802af159'
    end
    it 'returns md5 hexdigest' do
      expect(@connection.checksum('2015-09-01', '2015-09-03')).to eq("5439de2fa578c75d1d9ba4195efc663c")
    end
  end

  describe "#request" do

    it "returns a parsed response when the response is a 200" do
      response = double :status => 200, :body => '<tag>This is the contents</tag>'
      response = @connection.request { response }
      expect(response).to be_kind_of(Hash)
    end
  end
end
