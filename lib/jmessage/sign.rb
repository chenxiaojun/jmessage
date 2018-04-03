require 'base64'
module Jmessage
  class Sign
    def self.authorize
      Base64.strict_encode64(Jmessage.app_key+':'+Jmessage.master_secret)
    end
  end
end