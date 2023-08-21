require 'rails_helper'

RSpec.describe AccountRepository do
  describe '.create' do
    let(:account_params) { attributes_for(:account) }

    it 'creates a new account' do
      expect { described_class.create(account_params) }.to change(Account, :count).by(1)
    end
  end

  describe '.find_by_cpf' do
    let!(:account) { FactoryBot.create(:account) }

    it 'returns an account with the matching CPF' do
      expect(described_class.find_by_cpf(account.holder_cpf)).to eq(account)
    end
  end

end
