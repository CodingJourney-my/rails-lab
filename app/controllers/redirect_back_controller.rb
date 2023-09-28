class RedirectBackController < ApplicationController
  def index
    puts CGI.unescape(request.referer)
    cookies[:referer] = { value: CGI.unescape(request.referer) }
    puts request.referer, cookies[:referer]
  end
end
