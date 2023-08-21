class AccountRepository
  def self.create(params)
    Account.create(params)
  end

  def self.find_by_cpf(cpf)
    Account.find_by(holder_cpf: cpf)
  end

  def self.find_by_id(id)
    Account.find_by(id:)
  end

  def self.find_and_lock_by_id(id)
    Account.lock.find(id)
  end

  def self.update_balance(account:, amount_in_cents:)
    account.update!(balance_in_cents: account.balance_in_cents + amount_in_cents)
  end
end
