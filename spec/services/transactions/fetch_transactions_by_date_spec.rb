require 'rails_helper'

RSpec.describe Transactions::FetchTransactionsByDate do
  describe '#call' do
    let!(:account) { FactoryBot.create(:account) }
    let!(:transaction1) { FactoryBot.create(:transaction, created_at: 2.days.ago, debit_account: account) }
    let!(:transaction2) { FactoryBot.create(:transaction, created_at: 1.day.ago, debit_account: account) }
    let(:service) { described_class.new(account_id: account.id, start_date: 3.days.ago, end_date: Time.zone.today) }

    context 'when transactions exist within the date range' do
      it 'returns the transactions' do
        result = service.call

        expect(result[:success]).to be_truthy
        expect(result[:transactions]).to contain_exactly(transaction1, transaction2)
      end
    end

    context 'when no transactions exist within the date range' do
      let(:service) { described_class.new(account_id: account.id, start_date: 5.days.ago, end_date: 4.days.ago) }

      it 'returns an empty array' do
        result = service.call

        expect(result[:success]).to be_truthy
        expect(result[:transactions]).to be_empty
      end
    end

    context 'when an exception occurs' do
      before do
        allow(Transaction).to receive(:where).and_raise('Some error')
      end

      it 'returns the error message' do
        result = service.call

        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Some error')
      end
    end
  end
end
