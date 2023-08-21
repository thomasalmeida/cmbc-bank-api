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
end
