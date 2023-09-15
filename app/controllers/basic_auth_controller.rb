class BasicAuthController < ApplicationController
  http_basic_authenticate_with name: 'username', password: 'password'

  def index
  end
end
