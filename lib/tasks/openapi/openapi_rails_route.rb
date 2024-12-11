module Openapi
  class RailsRoute

    class << self
      def find(path, verb)
        req = ActionDispatch::Request.new({"REQUEST_METHOD" => verb.to_s.upcase, "PATH_INFO" => path})
        # original_route = Rails.application.routes.routes.simulator.memos(path){[]}.find{|r| r.matches?(req)}
        original_route = Rails.application.routes.routes.simulator.memos(path){[]}.select{|r| r.matches?(req)}.sort_by(&:precedence).first
        return nil if original_route.blank?
        new(original_route)
      end
    end

    attr_reader :route
    def initialize(route)
      @route = route
    end

    # TODO:
    # (:format) is needed when you support format in openapi like `/report.{format}`
    def path
      route.path.spec.to_s.sub(/\([^\)]+\)/, '')
    end

    def verb
      route.verb
    end

    def content_type
      x = route.defaults[:format] || :json
      Mime[x].to_s
    end

    def controller
      route.defaults[:controller]
    end

    def action
      route.defaults[:action]
    end

    def action_key
      "#{controller.gsub('/', ':')}.#{action}"
    end

    def summary
      action_key.split(/\:|\./).join(' ')
    end
    
    def path_variables
      path.split('/').select{|x| x.starts_with?(':')}.map{|x| x[1..]}
    end

    def expects_array_response?
      action == 'index'
    end
  end
end
