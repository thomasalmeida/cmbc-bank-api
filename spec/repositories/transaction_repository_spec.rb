require 'rails_helper'

RSpec.describe TransactionRepository do
  describe '.create' do
    let(:sender) { FactoryBot.create(:account) }
    let(:receiver) { FactoryBot.create(:account) }
    let(:transaction_params) do
      {
        sender:,
        receiver:,
        amount_in_cents: 100
      }
    end

    it 'creates a new transaction' do
      expect { described_class.create(**transaction_params) }
        .to change(Transaction, :count).by(1)
    end
  end

  describe '.find_by_date_range' do
    let(:account) { FactoryBot.create(:account) }
    let(:start_date) { Time.zone.today.beginning_of_month }
    let(:end_date) { Time.zone.today.end_of_month }
    let!(:transaction1) { FactoryBot.create(:transaction, debit_account: account, created_at: start_date + 1.day) }
    let!(:transaction2) { FactoryBot.create(:transaction, credit_account: account, created_at: start_date + 2.days) }

    it 'returns transactions within the specified date range for an account' do
      result = described_class.find_by_date_range(account_id: account.id, start_date:, end_date:)
      expect(result).to match_array([transaction1, transaction2])
    end
  end
end
