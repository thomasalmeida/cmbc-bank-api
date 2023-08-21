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
end
