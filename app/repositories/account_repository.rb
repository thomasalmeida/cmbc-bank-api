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

end
