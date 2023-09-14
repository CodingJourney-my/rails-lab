class BaseController < ApplicationController
  include Error

  def render_data( data, **args )
    status = args.delete(:status)
    render json: args.merge(data: data), status: (status.presence || 200)
  end

  def render_error( code, status:, **args )
    render json: {success: false, code: code}.merge(args), status: status
  end

  def current_offset
    (params[:offset].presence || 0).to_i
  end

  def current_limit( default=30 )
    (params[:limit].presence || default).to_i
  end
end
