class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :payer_id
      t.integer :ower_id
      t.string :payee
      t.string :memo
      t.date :date
      t.decimal :amount_paid
      t.decimal :amount_lent
      t.date :reconciled_on

      t.timestamps
    end
    add_index :transactions, :date
    add_foreign_key :transactions, :people, column: :payer_id
    add_foreign_key :transactions, :people, column: :ower_id
  end
end
