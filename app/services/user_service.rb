class UserService

  def initialize(user)
    @user = user
  end

  def webhook(zipcode)
    {zip_code: zipcode, email: @user.email, total: @user.addresses.count}
  end
 
end
