require 'rails_helper'

RSpec.describe Transactions::CreateTransaction do
  describe '#call' do
    let!(:sender) { FactoryBot.create(:account, balance_in_cents: 10_000) }
    let!(:receiver) { FactoryBot.create(:account, balance_in_cents: 1_000) }
    let(:amount_in_cents) { 5_000 }
    let(:service) { described_class.new(sender_id: sender.id, receiver_id: receiver.id, amount_in_cents:) }

    context 'successful transaction' do
      it 'transfers the amount from sender to receiver' do
        initial_transaction_count = Transaction.count

        result = service.call
        sender.reload
        receiver.reload

        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Transaction completed')
        expect(sender.balance_in_cents).to eq(5_000)
        expect(receiver.balance_in_cents).to eq(6_000)

        expect(Transaction.count).to eq(initial_transaction_count + 1)
      end
    end

    context 'when an account is invalid' do
      let!(:receiver) { nil }
      let(:service_with_invalid_receiver) { described_class.new(sender_id: sender.id, receiver_id: receiver&.id, amount_in_cents:) }

      it 'returns an error' do
        result = service_with_invalid_receiver.call

        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq("Couldn't find Account without an ID")
      end
    end

    context 'insufficient funds' do
      let(:amount_in_cents) { 15_000 }

      it 'returns an error' do
        result = service.call

        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Insufficient balance')
      end
    end

    context 'exception raised during the transaction process' do
      before do
        allow_any_instance_of(Account).to receive(:update!).and_raise('Some error')
      end

      it 'returns the exception error message' do
        result = service.call

        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Some error')
      end
    end
  end
end
