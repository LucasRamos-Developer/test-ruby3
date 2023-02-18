require 'net/http'
require 'json'

class RequestService

  def get_address_by_zipcode(zip)
    endpoint = "https://viacep.com.br/ws/#{zip}/json/"
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host)
    http.read_timeout = 2
    req = Net::HTTP::Get.new(endpoint, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    resp = JSON.parse(http.request(req).body)
    raise Zipcode::NotfoundError if (resp.has_key?('erro'))
    resp
  end

  def send_wehook(url, body)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = body.to_json
    http.request(request)
  end
end
