class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end

  def new
    @expense = Expense.new
    @people = Person.where.not(id: @current_user).all
  end

  def create
    other_person = Person.find(params[:person][:id])
    if params[:person_paid] == "current"
      @expense = Expense.split_between_two_people(@current_user, other_person, expense_params())
    elsif params[:person_paid] == "other"
      @expense = Expense.split_between_two_people(other_person, @current_user, expense_params())
    else
      raise StandardError.new("Unrecognized person_paid parameter")
    end
    if @expense.save
      flash[:info] = "Transaction was successfully created."
      redirect_to expenses_path
    else
      @people = Person.where.not(id: @current_user).all
      render :new
    end
  end

  private
    def expense_params
      params.require(:expense).permit(:dollar_amount_paid, :date, :payee, :memo)
    end
end
