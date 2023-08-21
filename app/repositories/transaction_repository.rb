class TransactionRepository
  def self.create(sender:, receiver:, amount_in_cents:)
    Transaction.create(debit_account: sender, credit_account: receiver, amount_in_cents:)
  end
end
