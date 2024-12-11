require_relative "./openapi_generator"
require_relative "./openapi_rails_route"
require_relative "./openapi_http_client"

class Openapi::TaskExec
  attr_reader :route, :req, :res
  attr_reader :shared_parameters
  def initialize(route, req, res, shared_parameters: {})
    @route = route
    @req = req
    @res = res
    @shared_parameters = shared_parameters
  end

  def path_variables
    req.rails_route&.path_variables || []
  end

  def openapi_response(description=nil)
    res.openapi_response(description)
  end

  def openapi_path_parameters
    path_variables.map{|var|
      shared_parameters.key?(var.to_sym) ?
        shared_parameters[var.to_sym].merge(in: "path", required: true) :
        {name: var.to_s, in: "path", required: true}
    }
  end

  def openapi_parameters(*extras)
    parameters = openapi_path_parameters
    parameters += shared_parameters.values_at(*extras)
    parameters
  end
end

class Openapi::ApiClient::Runner
  delegate_missing_to :client
  attr_reader :client, :generator
  def initialize(client, generator, shared_parameters: {})
    @client = client
    @generator = generator
    @shared_parameters = shared_parameters
  end

  def run(verb, path, **options, &block)
    # req = client.build_request(*args)
    req = client.build_request(verb, path, **options)
    Openapi::ApiRequest::Runner.new(req, generator, shared_parameters: @shared_parameters).run(&block)
  end
end

class Openapi::ApiRequest::Runner
  delegate_missing_to :req
  attr_reader :req, :generator
  def initialize(req, generator, shared_parameters: {})
    @req = req
    @generator = generator
    @shared_parameters = shared_parameters
  end

  def run(&block)
    res = req.execute!
    route = req.to_openapi_route
    route.responses << res.to_openapi_response
    generator << if block_given?
      task = Openapi::TaskExec.new(route, req, res, shared_parameters: @shared_parameters)
      task = task.tap(&block)
      task.route
    else
      route
    end
    [req, res]
  end
end
