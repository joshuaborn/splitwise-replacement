class ExpensesController < ApplicationController
  # GET /Expenses or /Expenses.json
  def index
    @expenses = Expense.all
  end
end
