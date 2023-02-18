class AddressesSearchService
  def initialize(zip, user)
    raise Zipcode::FormatError unless Address.valid_zip(zip)
    @user = user
    @zip = zip
  end

  def execute
    address = address_service.save
    address.result
  end

  private

  def request_service
    @request_service ||= RequestService.new
  end

  def address_service
    @address_service ||= AddressesService.new(request_service.get_address_by_zipcode(@zip), @user)
  end
end