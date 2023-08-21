require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:debit_transactions).class_name('Transaction').with_foreign_key('debit_account_id') }
    it { should have_many(:credit_transactions).class_name('Transaction').with_foreign_key('credit_account_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:holder_first_name) }
    it { should validate_presence_of(:holder_last_name) }
    it { should validate_presence_of(:balance_in_cents) }
    it { should validate_presence_of(:holder_cpf) }
    it { should validate_numericality_of(:balance_in_cents).is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:holder_cpf).case_insensitive }

    describe 'CPF format validation' do
      let(:account) { FactoryBot.build(:account) }

      context 'with a valid CPF format' do
        it 'is valid' do
          account.holder_cpf = '12345678901'
          expect(account).to be_valid
        end
      end

      context 'with an invalid CPF format' do
        it 'is not valid' do
          account.holder_cpf = '123456789012'
          expect(account).not_to be_valid
          expect(account.errors[:holder_cpf]).to include('CPF should have exactly 11 digits')
        end
      end
    end
  end
end
