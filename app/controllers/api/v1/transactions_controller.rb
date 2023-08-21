module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        result = Transactions::CreateTransaction.new(
          sender_id: transaction_params[:sender_id],
          receiver_id: transaction_params[:receiver_id],
          amount_in_cents: transaction_params[:amount_in_cents]
        ).call

        if result[:success]
          render json: { message: result[:message] }, status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.permit(:sender_id, :receiver_id, :amount_in_cents)
      end
    end
  end
end
