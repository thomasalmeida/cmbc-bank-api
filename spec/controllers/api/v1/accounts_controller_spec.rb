require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:account) }

      it 'creates a new account' do
        expect do
          post :create, params: valid_params
        end.to change(Account, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { account: { holder_first_name: 'OnlyName' } } }

      it 'does not create a new account' do
        expect do
          post :create, params: invalid_params
        end.not_to change(Account, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #balance' do
    let(:account) { FactoryBot.create(:account) }

    before do
      allow(controller).to receive(:authenticate_request).and_return(true)
      allow(controller).to receive(:current_account).and_return(account)
    end

    it 'fetches balance for the authenticated account' do
      get :balance
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['balance_in_cents']).to eq(account.balance_in_cents)
    end
  end
end
