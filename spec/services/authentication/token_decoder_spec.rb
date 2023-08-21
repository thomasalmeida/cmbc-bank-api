require 'rails_helper'

RSpec.describe Authentication::TokenDecoder do
  describe '#decode' do
    subject(:service) { described_class.new(token) }

    let(:account) { FactoryBot.create(:account) }

    context 'with valid token' do
      let(:token) { JsonWebToken.encode(account_id: account.id) }

      it 'returns the decoded token data' do
        result = service.decode
        expect(result[:account_id]).to eq(account.id)
      end
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }

      it 'returns nil' do
        result = service.decode
        expect(result).to be_nil
      end
    end
  end
end
