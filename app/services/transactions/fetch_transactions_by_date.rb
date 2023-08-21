module Transactions
  class FetchTransactionsByDate
    def initialize(account_id:, start_date:, end_date:)
      @account_id = account_id
      @start_date = start_date
      @end_date = end_date
    end

    def call
      transactions = TransactionRepository.find_by_date_range(
        account_id: @account_id,
        start_date: @start_date,
        end_date: @end_date
      )

      { success: true, transactions: }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
