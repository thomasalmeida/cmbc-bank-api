module Transactions
  class CreateTransaction
    def initialize(sender_id:, receiver_id:, amount_in_cents:)
      @sender_id = sender_id
      @receiver_id = receiver_id
      @amount_in_cents = amount_in_cents.to_i
    end

    def call
      ActiveRecord::Base.transaction do
        sender = AccountRepository.find_and_lock_by_id(@sender_id)
        receiver = AccountRepository.find_and_lock_by_id(@receiver_id)

        raise 'Invalid accounts' unless sender && receiver
        raise 'Insufficient balance' if sender.balance_in_cents < @amount_in_cents

        AccountRepository.update_balance(account: sender, amount_in_cents: -@amount_in_cents)
        AccountRepository.update_balance(account: receiver, amount_in_cents: @amount_in_cents)
        TransactionRepository.create(sender:, receiver:, amount_in_cents: @amount_in_cents)
      end

      { success: true, message: 'Transaction completed' }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
