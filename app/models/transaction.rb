class Transaction < ApplicationRecord
  belongs_to :credit_account, class_name: 'Account'
  belongs_to :debit_account, class_name: 'Account'

  validate :sufficient_funds
  validate :not_reverted, on: :update

  private

  def sufficient_funds
    return unless debit_account.balance_in_cents < amount_in_cents

    errors.add(:amount_in_cents, 'Insufficient funds')
  end

  def not_reverted
    return unless reversed_at_was && reversed_at_changed?

    errors.add(:reversed_at, 'Transaction has already been reversed')
  end
end
