module Api
  module V1
    class AccountsController < ApplicationController
      def create
        result = Accounts::CreateAccount.new(
          name: account_params[:holder_first_name],
          last_name: account_params[:holder_last_name],
          cpf: account_params[:holder_cpf],
          balance_in_cents: account_params[:balance_in_cents],
          password: account_params[:password],
          password_confirmation: account_params[:password_confirmation]
        ).call

        if result[:success]
          success_response({ account: result[:account] }, :created)
        else
          error_response(result[:errors])
        end
      end

      private

      def account_params
        params.permit(
          :holder_first_name,
          :holder_last_name,
          :holder_cpf,
          :balance_in_cents,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
