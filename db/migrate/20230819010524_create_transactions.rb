class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :debit_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid
      t.references :credit_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid
      t.integer :amount_in_cents, null: false
      t.datetime :processed_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :reversed_at

      t.timestamps
    end
  end
end
