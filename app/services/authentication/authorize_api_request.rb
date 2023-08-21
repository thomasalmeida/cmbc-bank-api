module Authentication
  class AuthorizeApiRequest
    def initialize(headers:)
      @headers = headers
    end

    def call
      if account
        { account: }
      else
        { error: error_message }
      end
    end

    private

    attr_reader :headers

    def account
      @account ||= AccountRepository.find_by_id(decoded_auth_token[:account_id]) if decoded_auth_token
    end

    def decoded_auth_token
      @decoded_auth_token ||= TokenDecoder.new(http_auth_header).decode
    end

    def http_auth_header
      headers['Authorization']&.split(' ')&.last
    end

    def error_message
      return 'Missing token' if headers['Authorization'].blank?

      'Invalid token'
    end
  end
end
