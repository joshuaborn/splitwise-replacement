class CreatePersonTransactionJoinModel < ActiveRecord::Migration[7.2]
  def change
    create_table :person_transactions do |t|
      t.integer :transaction_id
      t.integer :person_id
      t.decimal :amount

      t.timestamps
    end
    add_foreign_key :person_transactions, :transactions, column: :transaction_id
    add_foreign_key :person_transactions, :people, column: :person_id
    remove_column :transactions, :first_person_id, :integer
    remove_column :transactions, :second_person_id, :integer
    remove_column :transactions, :amount_lent, :decimal
  end
end
