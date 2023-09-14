module Error
  # USAGE: raise Error::BadRequest, code: 'invalid_request', message: 'param is invalid'

  class Base < StandardError
    @status = nil
    @default_message = nil

    class << self
      attr_accessor :status
      attr_accessor :default_message
      def inherited( klass )
        klass.status = @status
        klass.default_message = @default_message
      end
      def code
        self.to_s.demodulize.underscore
      end
    end
    
    # @param: {code: string, message: string, ...}
    def initialize( error )
      @code = error.delete(:code)
      @message = error.delete(:message)
      @options = error
    end

    def message
      @message.presence || self.class.default_message
    end

    def code
      @code.presence || self.class.code
    end

    def options
      @options
    end

    def status
      self.class.status
    end

    def payload
      {
        code: code,
        message: message,
      }
    end
  end

  class BadRequest < Base
    @status = 400
  end
  class Unauthorized < Base
    @status = 401
  end
  class Forbidden < Base
    @status = 403
  end
  class NotFound < Base
    @status = 404
  end
  class InternalServerError < Base
    @status = 500
  end
  class ServiceUnavailable < Base
    @status = 503
  end

  class UknownError < InternalServerError; end
  class UnderMaintenance < ServiceUnavailable; end

  class TokenUnauthorized < Unauthorized; end
  class TokenExpired < Unauthorized; end
  class IpBlocked < Forbidden; end
  
  class AuthenticationFailed < Unauthorized; end
  class AuthorizationViolated < Forbidden; end
  class InputInvalid < BadRequest; end
  class OperationIncompleted < BadRequest; end

  def self.catchables
    [
      NotFound,
      BadRequest,
      Unauthorized,
      Forbidden,
      UknownError,
      UnderMaintenance,
      TokenUnauthorized,
      TokenExpired,
      IpBlocked,
      AuthenticationFailed,
      AuthorizationViolated,
      InputInvalid,
      OperationIncompleted,
    ]
  end

end
