module AuthenticatedController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  attr_reader :current_account

  private

  def authenticate_request
    result = Authentication::AuthorizeApiRequest.new(headers: request.headers).call
    if result[:account]
      @current_account = result[:account]
    else
      error_response(result[:error] || 'Not Authorized', :unauthorized)
    end
  end
end
