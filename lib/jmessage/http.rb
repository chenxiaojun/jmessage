require 'faraday'
require 'json'

module Jmessage
  class Http
    attr_accessor :conn, :response

    def initialize(form=false)
      self.conn = Faraday.new(url: remote_path) do |faraday|
        faraday.request  :multipart if form
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.headers = headers
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(uri)
      self.response = conn.get { |req| set_req(req, uri) }
      parse_body
    end

    def post(uri, params = {})
      self.response = conn.post { |req| set_req(req, uri, params) }
      parse_body
    end

    def put(uri, params = {})
      self.response = conn.put { |req| set_req(req, uri, params) }
    end

    def delete(uri, params = {})
      self.response = conn.delete { |req| set_req(req, uri, params) }
    end

    def post_image(uri, params={})
      self.response = conn.post do |req|
        req.url uri
        req.body = { image: imageio(params[:image]) }
      end
      parse_body
    end

    def parse_body
      JSON(response.body)
    end

    def imageio(image)
      if image.instance_of?(Tempfile)
        return Faraday::UploadIO.new(image.path, image.content_type, tempfile_name(image))
      end
      Faraday::UploadIO.new(image.path, image.content_type)
    end

    def tempfile_name(file)
      extension = file.content_type.split('/').last
      extension = extension.downcase.eql?('jpeg') ? 'jpg' : extension
      File.basename(file) + '.' + extension
    end

    def headers
      {
        'Authorization' => "Basic #{Jmessage::Sign.authorize}",
        'Accept' => 'application/json'
      }
    end

    def set_req(req, uri, params = {})
      req.url uri
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON(params) unless params.empty?
    end

    def remote_path
      'https://api.im.jpush.cn'
    end
  end
end