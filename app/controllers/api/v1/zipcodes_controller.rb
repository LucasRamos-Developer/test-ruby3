class Api::V1::ZipcodesController < ApplicationController
  before_action :authenticate_user!

  before_action :webhook, only: [:search]

  def search
    zip = params[:zipcode]
    if valid_zip(zip)
      request_service = request_service(zip)
      res = request_service.result

      render json: res[0], status: res[1]
    else
      render json: {error: {message: 'CEP INVÁLIDO'}}, status: :bad_request
    end
  end

  private

  def webhook
    request_service = request_service(zip)
    request_service.send
  end

  def valid_zip(zip)
    /^\d{5}-?\d{3}$/.match zip
  end

  def request_service
    @request ||= RequestService.new(zip, current_user)
  end

end