module Beslist
  module API

    class Connection

      module Requests

        def request(options = {})
          response = yield
          status = response.status.to_i
          case status
          when 401
          else
            MultiXml.parse(response.body)
          end
        end
      end

    end

  end
end
