module Authentication
  class TokenDecoder
    def initialize(token)
      @token = token
    end

    def decode
      JsonWebToken.decode(@token)
    rescue StandardError
      nil
    end
  end
end
