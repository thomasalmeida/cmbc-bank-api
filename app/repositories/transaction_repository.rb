class TransactionRepository
  def self.create(sender:, receiver:, amount_in_cents:)
    Transaction.create(debit_account: sender, credit_account: receiver, amount_in_cents:)
  end

  def self.find_by_id(id)
    Transaction.find_by(id:)
  end

  def self.mark_as_reversed(transaction)
    transaction.update!(reversed_at: Time.current)
  end

  def self.find_by_date_range(account_id:, start_date:, end_date:)
    Transaction.where('debit_account_id = ? OR credit_account_id = ?', account_id, account_id)
               .where(created_at: start_date..end_date)
               .order(:created_at)
  end
end
