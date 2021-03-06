class UserAuthenticator

  def initialize(user, session, authenticator_finder = Users::OmniauthCallbacksController)
    @user = user
    @session = session[:authentication]
    @authenticator_finder = authenticator_finder
  end

  def start
    if authenticated?
      @user.active = true
    else
      @user.password_required!
    end

    # @user.skip_email_validation = true if @session && @session[:skip_email_validation].present?
    @user.skip_email_validation = true
  end

  def has_authenticator?
    !!authenticator
  end

  def finish
    authenticator.after_create_account(@user, @session) if authenticator
    @session = nil
  end

  def email_valid?
    !!@session
    # @session && @session[:email_valid]
  end

  def authenticated?
    !!@session # && @session[:btc_wallet_address] == @user.btc_wallet_address
    # @session && @session[:email] == @user.email && @session[:email_valid]
  end

  private

  def authenticator
    if authenticator_name
      @authenticator ||= @authenticator_finder.find_authenticator(authenticator_name)
    end
  end

  def authenticator_name
    @session && @session[:authenticator_name]
  end

end
