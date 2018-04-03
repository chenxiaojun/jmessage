require 'jmessage/version'
require 'jmessage/sign'
require 'jmessage/http'
require 'jmessage/user'

module Jmessage
  class << self
    attr_accessor :app_key, :master_secret
  end
end
