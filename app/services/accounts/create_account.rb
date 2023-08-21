module Accounts
  class CreateAccount
    def initialize(name:, last_name:, cpf:, balance_in_cents:, password:, password_confirmation:)
      @name = name
      @last_name = last_name
      @cpf = cpf
      @balance_in_cents = balance_in_cents
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      params = {
        holder_first_name: @name,
        holder_last_name: @last_name,
        holder_cpf: @cpf,
        balance_in_cents: @balance_in_cents,
        password: @password,
        password_confirmation: @password_confirmation
      }

      account = AccountRepository.create(params)

      if account.persisted?
        { success: true, account: account.as_json(except: [:password_digest]) }
      else
        { success: false, errors: account.errors.full_messages }
      end
    end
  end
end
