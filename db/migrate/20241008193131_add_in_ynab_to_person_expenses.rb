class AddInYnabToPersonExpenses < ActiveRecord::Migration[7.2]
  def change
    add_column :person_expenses, :in_ynab, :boolean
  end
end
