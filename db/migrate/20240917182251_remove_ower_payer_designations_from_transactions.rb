class RemoveOwerPayerDesignationsFromTransactions < ActiveRecord::Migration[7.2]
  def change
    remove_column :transactions, :payer_id, :integer
    remove_column :transactions, :ower_id, :integer
    add_column :transactions, :first_person_id, :integer
    add_column :transactions, :second_person_id, :integer
    add_foreign_key :transactions, :people, column: :first_person_id
    add_foreign_key :transactions, :people, column: :second_person_id
  end
end
