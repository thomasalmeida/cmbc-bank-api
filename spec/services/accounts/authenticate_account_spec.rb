require 'rails_helper'

RSpec.describe Accounts::AuthenticateAccount do
  describe '#call' do
    subject(:service) { described_class.new(cpf:, password:) }

    let!(:account) { FactoryBot.create(:account, password: 'password', password_confirmation: 'password') }

    context 'with valid credentials' do
      let(:cpf) { account.holder_cpf }
      let(:password) { 'password' }

      it 'returns success and a token' do
        result = service.call
        expect(result[:success]).to be_truthy
        expect(result[:token]).to be_present
      end
    end

    context 'with invalid password' do
      let(:cpf) { account.holder_cpf }
      let(:password) { 'wrong_password' }

      it 'returns an error' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Invalid credentials')
      end
    end

    context 'with non-existent account' do
      let(:cpf) { 'non_existent_cpf' }
      let(:password) { 'password' }

      it 'returns an error' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Invalid credentials')
      end
    end
  end
end
