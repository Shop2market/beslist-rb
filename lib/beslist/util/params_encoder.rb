module Beslist
  module ParamsEncoder
    def self.encode(params)
      params.map do |k, v|
        case v
        when Array, Hash
          "#{k}=#{URI.escape(JSON.dump(v))}"
        else
          "#{k}=#{v}"
        end
      end.join('&')
    end

    def self.decode(string)
      string
    end
  end
end
