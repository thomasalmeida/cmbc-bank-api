class Account < ApplicationRecord
  has_secure_password

  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'debit_account_id'
  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'credit_account_id'

  validates :holder_first_name, presence: true
  validates :holder_last_name, presence: true
  validates :balance_in_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :holder_cpf, presence: true, uniqueness: true,
                         format: { with: /\A\d{11}\z/, message: 'CPF should have exactly 11 digits' }
end
