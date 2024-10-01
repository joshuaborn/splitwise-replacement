module ExpensesHelper
  def group_by_date(person_expenses)
    person_expenses.inject({}) do |this_hash, this_person_expense|
      this_date = localize this_person_expense.expense.date, format: :ynab
      unless this_hash.include?(this_date)
        this_hash[this_date] = []
      end
      this_hash[this_date].unshift(this_person_expense)
      this_hash
    end
  end
end
