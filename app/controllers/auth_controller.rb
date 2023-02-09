class AuthController < ApplicationController
  before_action :check_authentication

  def check_authentication
    render login_url unless logged_in?
  end
end
