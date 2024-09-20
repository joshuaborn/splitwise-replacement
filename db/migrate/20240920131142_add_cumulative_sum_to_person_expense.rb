class AddCumulativeSumToPersonExpense < ActiveRecord::Migration[7.2]
  def change
    add_column :person_expenses, :cumulative_sum, :integer
  end
end
