require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let!(:transaction) { FactoryBot.create(:transaction, debit_account: account, created_at: 5.days.ago) }

  before do
    allow(controller).to receive(:authenticate_request).and_return(true)
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET #index' do
    context 'with valid date range' do
      it 'returns transactions' do
        get :index, params: { start_date: 10.days.ago.to_date, end_date: Time.zone.today }

        expect(response.parsed_body['transactions']).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid date range' do
      it 'returns empty array' do
        get :index, params: { start_date: nil, end_date: '' }

        expect(response.parsed_body['transactions']).to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without date range' do
      it 'returns all transactions' do
        get :index, params: { start_date: nil, end_date: nil }

        expect(response.parsed_body['transactions']).to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
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
