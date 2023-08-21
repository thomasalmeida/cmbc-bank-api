require 'rails_helper'

RSpec.describe Transactions::ReverseTransaction do
  describe '#call' do
    let(:debit_account) { FactoryBot.create(:account) }
    let(:credit_account) { FactoryBot.create(:account) }

    context 'successfully reversing a transaction' do
      let!(:transaction) { FactoryBot.create(:transaction, debit_account:, credit_account:) }
      let(:service) { described_class.new(transaction.id) }

      it 'reverses the transaction and adjusts account balances' do
        result = service.call
        transaction.reload

        expect(result[:success]).to eq(true)
        expect(result[:message]).to eq('Transaction reversed')
        expect(transaction.reversed_at).not_to be_nil
      end
    end

    context 'when transaction does not exist' do
      let(:invalid_transaction_id) { -1 }
      let(:service) { described_class.new(invalid_transaction_id) }

      it 'returns an error' do
        result = service.call

        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq('Transaction not found')
      end
    end

    context 'when transaction has already been reversed' do
      let!(:transaction) { FactoryBot.create(:transaction, debit_account:, credit_account:, reversed_at: Time.zone.now) }
      let(:service) { described_class.new(transaction.id) }

      it 'returns an error' do
        result = service.call

        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq('Transaction already reversed')
      end
    end

    context 'when an exception occurs during reversing' do
      let!(:transaction) { FactoryBot.create(:transaction, debit_account:, credit_account:) }
      let(:service) { described_class.new(transaction.id) }

      before do
        allow_any_instance_of(Transaction).to receive(:update!).and_raise('Some error')
      end

      it 'returns the error message' do
        result = service.call

        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq('Some error')
      end
    end
  end
end
