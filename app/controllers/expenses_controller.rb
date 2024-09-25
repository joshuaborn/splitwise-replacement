class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end

  def new
    @expense = Expense.new
    @people = Person.where.not(id: @current_user).all
  end
end
