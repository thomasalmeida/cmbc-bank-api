module Transactions
  class ReverseTransaction
    def initialize(transaction_id)
      @transaction_id = transaction_id
    end

    def call
      transaction = TransactionRepository.find_by_id(@transaction_id)

      return { success: false, error: 'Transaction not found' } if transaction.nil?
      return { success: false, error: 'Transaction already reversed' } if transaction.reversed_at

      ActiveRecord::Base.transaction do
        sender = AccountRepository.find_and_lock_by_id(transaction.debit_account.id)
        receiver = AccountRepository.find_and_lock_by_id(transaction.credit_account.id)

        AccountRepository.update_balance(account: receiver, amount_in_cents: -transaction.amount_in_cents)
        AccountRepository.update_balance(account: sender, amount_in_cents: transaction.amount_in_cents)

        TransactionRepository.mark_as_reversed(transaction)
      end

      { success: true, message: 'Transaction reversed' }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
