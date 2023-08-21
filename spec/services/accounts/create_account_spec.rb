require 'rails_helper'

RSpec.describe Accounts::CreateAccount do
  describe '#call' do
    subject(:service) { described_class.new(**account_params) }

    let!(:base_params) do
      account_attrs = attributes_for(:account)
      {
        name: account_attrs[:holder_first_name],
        last_name: account_attrs[:holder_last_name],
        cpf: account_attrs[:holder_cpf],
        balance_in_cents: account_attrs[:balance_in_cents],
        password: 'passwordxxx',
        password_confirmation: 'passwordxxx'
      }
    end

    context 'with valid parameters' do
      let(:account_params) { base_params }

      it 'returns success and account data' do
        result = service.call
        expect(result[:success]).to be_truthy
        expect(result[:account]).to be_present
      end

      it 'persists the account' do
        service.call
        expect(Account.where(holder_cpf: account_params[:cpf])).to exist
      end
    end

    context 'with invalid parameters' do
      let(:account_params) { base_params.merge(cpf: 'invalid') }

      it 'returns error messages' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include('Holder cpf CPF should have exactly 11 digits')
      end
    end

    context 'when first name is missing' do
      let(:account_params) { base_params.merge(name: '') }

      it 'returns error messages' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include("Holder first name can't be blank")
      end
    end

    context 'when last name is missing' do
      let(:account_params) { base_params.merge(last_name: '') }

      it 'returns error messages' do
        result = service.call
        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include("Holder last name can't be blank")
      end
    end
  end
end
