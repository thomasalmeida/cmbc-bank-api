require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let!(:transaction) { FactoryBot.create(:transaction, debit_account: account, created_at: 5.days.ago) }

  before do
    allow(controller).to receive(:authenticate_request).and_return(true)
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'POST #create' do
    let(:receiver) { FactoryBot.create(:account) }

    context 'with valid params' do
      it 'creates a transaction' do
        post :create, params: { sender_id: account.id, receiver_id: receiver.id, amount_in_cents: 50 }

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an error' do
        post :create, params: { debit_account_id: account.id, credit_account_id: nil, amount_in_cents: 50 }

        expect(response.parsed_body['error']).to be_present
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
