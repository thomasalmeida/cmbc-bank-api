module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        result = Transactions::FetchTransactionsByDate.new(
          account_id: current_account.id,
          start_date: index_params[:start_date],
          end_date: index_params[:end_date]
        ).call

        if result[:success]
          render json: { transactions: result[:transactions] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

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

      def index_params
        params.permit(:start_date, :end_date)
      end

      def transaction_params
        params.permit(:sender_id, :receiver_id, :amount_in_cents)
      end
    end
  end
end
