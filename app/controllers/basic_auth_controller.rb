class BasicAuthController < BaseController
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # NOTE: Prevent timing attacks
      unless ActiveSupport::SecurityUtils.secure_compare(username, "user") && ActiveSupport::SecurityUtils.secure_compare(password, "password")
        raise Error::AuthenticationFailed.new(code: 'unauthorized', message: 'Authentication failed.')
      end
    end
  end
end