require 'rails_helper'
require 'jwt'

RSpec.describe JsonWebToken do
  let(:user_id) { 1 }
  let(:payload) { { user_id: } }
  let(:secret_key) { ENV.fetch('SECRET_KEY_BASE', nil) }
  let(:wrong_secret_key) { 'wrong_secret_key' }

  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      token = described_class.encode(payload)
      decoded_payload = JWT.decode(token, secret_key)[0]

      expect(decoded_payload['user_id']).to eq(user_id)
    end
  end

  describe '.decode' do
    context 'with a valid token' do
      let(:token) { described_class.encode(payload) }

      it 'decodes a JWT token' do
        decoded_payload = described_class.decode(token)

        expect(decoded_payload[:user_id]).to eq(user_id)
      end
    end

    context 'with an expired token' do
      let(:expired_token) { described_class.encode(payload, 1.hour.ago) }

      it 'returns nil' do
        expect(described_class.decode(expired_token)).to be_nil
      end
    end

    context 'with an invalid token' do
      let(:invalid_token) { JWT.encode(payload, wrong_secret_key) }

      it 'returns nil' do
        expect(described_class.decode(invalid_token)).to be_nil
      end
    end
  end
end
