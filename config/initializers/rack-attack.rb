require 'action_dispatch/http/mime_type'
class Rack::Attack
  throttle('limit logins per email', :limit => 6, :period => 10.minutes) do |req|
    if req.path == '/login' && req.post?
      req.params['email'].to_s.downcase.gsub(/\s+/, "")
    end
  end

  self.throttled_responder = lambda do |env|
    # lookup_context = ActionView::LookupContext.new('./views', {}, '')
    # lookup_context.cache = false   # ActionPachk を読まなくて済む魔法

    # view_context = ActionView::Base.new(lookup_context, {}, nil)
    # html = view_context.render(template: '429', prefixes: 'errors', layout: 'layouts/application')
    view = Class.new(ActionView::Base.with_empty_template_cache).with_view_paths('./app/views', {})
    [429, {'Content-Type' => 'text/html'}, [view.render(template: '429', prefixes: 'errors')]]
    # [429, {'Content-Type' => 'text/html'}, [view.render(template: '429', prefixes: 'errors', layout: 'layouts/application')]]
  end
end