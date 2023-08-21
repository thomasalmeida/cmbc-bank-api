module Accounts
  class AuthenticateAccount
    def initialize(cpf:, password:)
      @cpf = cpf
      @password = password
    end

    def call
      account = AccountRepository.find_by_cpf(@cpf)

      if account&.authenticate(@password)
        { success: true, token: JsonWebToken.encode(account_id: account.id) }
      else
        { success: false, error: 'Invalid credentials' }
      end
    end
  end
end
