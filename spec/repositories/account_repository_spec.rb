require 'rails_helper'

RSpec.describe AccountRepository do
  describe '.create' do
    let(:account_params) { attributes_for(:account) }

    it 'creates a new account' do
      expect { described_class.create(account_params) }.to change(Account, :count).by(1)
    end
  end

end
