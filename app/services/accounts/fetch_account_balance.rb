module Accounts
  class FetchAccountBalance
    def initialize(account_id:)
      @account_id = account_id
    end

    def call
      account = AccountRepository.find_by_id(@account_id)

      return { success: false, error: 'Account not found' } unless account

      { success: true, balance_in_cents: account.balance_in_cents }
    end
  end
end
