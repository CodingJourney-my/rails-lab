class RedirectBackController < ApplicationController
  def index
    cookies[:referer] = { value: request.referer, domain: '.example.com' }
    p request.referer, cookies[:referer]
  end
end
