module Zipcode
  class Error < StandardError
    attr_reader :message, :status

    def initialize(msg, status)
      @message = msg
      @status = status
    end
  end
end