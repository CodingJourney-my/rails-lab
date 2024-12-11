require_relative "./openapi_api"

namespace :openapi do

  namespace :api do
    # rails openapi:api:check > doc/api.yml
    desc 'Generate openapi specification yaml'
    task check: :environment do
      runner = Openapi::Api.new('default')
      runner.run
      puts runner.openapi.to_yaml
    end
  end
end
