require 'rails_helper'

RSpec.describe Authentication::AuthorizeApiRequest do
  describe '#call' do
    subject(:service) { described_class.new(headers:) }

    let!(:account) { FactoryBot.create(:account) }
    let(:token) { JsonWebToken.encode(account_id: account.id) }

    context 'with valid token' do
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'returns the associated account' do
        result = service.call
        expect(result[:account]).to eq(account)
      end
    end

    context 'with invalid token' do
      let(:headers) { { 'Authorization' => 'Bearer invalid_token' } }

      it 'returns an error message' do
        result = service.call
        expect(result[:error]).to eq('Invalid token')
      end
    end

    context 'without a token' do
      let(:headers) { {} }

      it 'returns an error message' do
        result = service.call
        expect(result[:error]).to eq('Missing token')
      end
    end
  end
end
