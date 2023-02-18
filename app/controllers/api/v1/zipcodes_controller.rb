class Api::V1::ZipcodesController < ApplicationController
  before_action :authenticate_user!

  def search
    address = address_search_service.execute()
    render json: {content: address, webhook: user_service.webhook(params[:zipcode])}, status: :ok
  rescue Zipcode::Error => e
    render json: {erroor: {message: e.message, status: e.status}}, status: e.status
  rescue Exception => e
    render json: {error: {message: e.message}}, status: :internal_server_error
  end

  private

  def address_search_service
    @address_search ||= AddressesSearchService.new(params[:zipcode], current_user)
  end

  def user_service
    @UserService ||= UserService.new(current_user)
  end
end