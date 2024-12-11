class DocsController < ApplicationController
  layout false

  before_action do
    raise CommonError::NotFound if Rails.env.production?
  end

  def index
    filename = params[:filename].ends_with?('.html') ? params[:filename] : "#{params[:filename]}.html"
    filename = filename.gsub('..', '').gsub('/', '')
    render file: Rails.root.join("doc/html/#{filename}")
  end
end
