require 'faraday'
require 'json'

module Jmessage
  class Http
    attr_accessor :conn, :response

    def initialize
      self.conn = Faraday.new(url: remote_path) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(uri)
      self.response = conn.get do |req|
        req.url uri
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Basic #{Jmessage::Sign.authorize}"
        req.options.timeout = 10
      end
      parse_body
    end

    def post(uri, params = {})
      self.response = conn.post do |req|
        req.url uri
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Basic #{Jmessage::Sign.authorize}"
        req.options.timeout = 10
        req.body = JSON(params)
      end
      parse_body
    end

    def put(uri, params = {})
      self.response = conn.put do |req|
        req.url uri
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Basic #{Jmessage::Sign.authorize}"
        req.options.timeout = 10
        req.body = JSON(params)
      end
    end

    def delete(uri, params = {})
      self.response = conn.delete do |req|
        req.url uri
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Basic #{Jmessage::Sign.authorize}"
        req.options.timeout = 10
        req.body = JSON(params)
      end
    end

    def parse_body
      JSON(response.body)
    end

    def remote_path
      'https://api.im.jpush.cn'
    end
  end
end