require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  describe 'POST #login' do
    let(:account) { FactoryBot.create(:account) }

    context 'with valid credentials' do
      it 'returns a token' do
        post :login, params: { cpf: account.holder_cpf, password: 'password123' }

        expect(response.parsed_body).to have_key('token')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid password' do
      it 'returns an unauthorized status' do
        post :login, params: { cpf: account.holder_cpf, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid cpf' do
      it 'returns an unauthorized status' do
        post :login, params: { cpf: 'wrongcpf', password: 'password123' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
