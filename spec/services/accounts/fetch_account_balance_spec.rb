require 'rails_helper'

RSpec.describe Accounts::FetchAccountBalance do
  describe '#call' do
    subject(:service) { described_class.new(account_id:) }

    context 'when the account exists' do
      let!(:account) { FactoryBot.create(:account) }
      let(:account_id) { account.id }

      it 'returns the correct balance' do
        result = service.call
        expect(result[:success]).to be_truthy
        expect(result[:balance_in_cents]).to eq(account.balance_in_cents)
      end
    end

    context 'when the account does not exist' do
      let(:account_id) { -1 }

      it 'returns an error' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Account not found')
      end
    end
  end
end
