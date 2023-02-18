module Zipcode
  class NotfoundError < Zipcode::Error
    def initialize
      super("Zip code Not Found", :not_found)
    end
  end
end