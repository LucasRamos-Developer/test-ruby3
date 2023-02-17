require 'net/http'
require 'json'

class RequestService
  def initialize(zip, user)
    @user = user
    @address = Address.find_by_zipcode(zip.gsub('-',''))
    unless @address.present?
      endpoint = "https://viacep.com.br/ws/#{zip}/json/"
      uri = URI.parse(endpoint)
      @http = Net::HTTP.new(uri.host)
      @http.read_timeout = 2
      @req = Net::HTTP::Get.new(endpoint, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end
  end

  def result
    if @address.present?
      [@address.result, :ok]
    else
      begin
        res = prepare_return_json(JSON.parse(@http.request(@req).body))
        AddressesService.new(res, @user).save
        [res, :ok]
      rescue Net::ReadTimeout
      rescue Net::OpenTimeout
        [{},:request_timeout]
      rescue Exception => e
        [{error: e.message}, :internal_server_error]
      end
    end
  end

  private

  def prepare_return_json(data)
    zip = data['cep'].to_s.gsub('-','')
    {
      street: data['logradouro'],
      address: "#{data['logradouro']}, #{data['bairro']} - #{data['localidade']}/#{data['uf']} #{zip}",
      neighborhood: data['bairro'],
      city: data['localidade'],
      state: data['uf'],
      zipcode: zip
    }
  end
end
