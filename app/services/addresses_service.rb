class AddressesService
  def initialize(data, user)
    @address = normalize(data)
    @user = user
  end

  def save
    address = Address.find_by_zipcode(@address['zipcode'])
    unless address
      address = Address.create(
        street: @address[:street],
        address: @address[:address],
        neighborhood: @address[:neighborhood],
        city: @address[:city],
        state: @address[:state],
        zipcode: @address[:zipcode],
        result: @address
      )
    end
    @user.addresses << address
    address
  end

  def normalize(data)
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