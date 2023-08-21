class ApplicationController < ActionController::API
  include AuthenticatedController
  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end
end
