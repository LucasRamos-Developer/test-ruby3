module Zipcode
  class FormatError <  Zipcode::Error
    def initialize
      super("Zip code error format", :bad_request)
    end
  end
end