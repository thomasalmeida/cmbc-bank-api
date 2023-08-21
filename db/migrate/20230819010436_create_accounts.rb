class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :holder_first_name, null: false
      t.string :holder_last_name, null: false
      t.string :holder_cpf, null: false, unique: true
      t.integer :balance_in_cents, null: false, default: 0
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :accounts, :holder_cpf, unique: true
  end
end
