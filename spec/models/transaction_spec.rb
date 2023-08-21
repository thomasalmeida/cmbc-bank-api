require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:debit_account).class_name('Account').without_validating_presence }
    it { should belong_to(:credit_account).class_name('Account').without_validating_presence }
  end

  describe 'validations' do
    let(:account_with_funds) { FactoryBot.create(:account, balance_in_cents: 200) }
    let(:account_without_funds) { FactoryBot.create(:account, balance_in_cents: 50) }
    let(:credit_account) { FactoryBot.create(:account) }

    context 'when debit account has sufficient funds' do
      subject { FactoryBot.build(:transaction, debit_account: account_with_funds, credit_account:, amount_in_cents: 150) }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when debit account has insufficient funds' do
      subject { FactoryBot.build(:transaction, debit_account: account_without_funds, credit_account:, amount_in_cents: 100) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:amount_in_cents]).to include('Insufficient funds')
      end
    end

    context 'when transaction is already reversed' do
      let(:transaction) { FactoryBot.create(:transaction, reversed_at: Time.current) }

      it 'cannot be reversed again' do
        transaction.reversed_at = 1.hour.from_now
        expect(transaction).not_to be_valid
        expect(transaction.errors[:reversed_at]).to include('Transaction has already been reversed')
      end
    end
  end
end
