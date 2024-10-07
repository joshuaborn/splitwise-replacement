class Expense < ApplicationRecord
  has_many :person_expenses, dependent: :destroy
  accepts_nested_attributes_for :person_expenses
  has_many :people, through: :person_expenses

  validates :payee, :date, presence: true
  validates :dollar_amount_paid, comparison: { greater_than: 0 }
  validates :person_expenses, length: { minimum: 2 }
  validates_associated :person_expenses
  validate :amounts_sum_to_amount_paid, :amounts_sum_to_near_zero

  def dollar_amount_paid
    self.amount_paid.to_f / 100
  end

  def dollar_amount_paid=(dollars)
    self.amount_paid = (100 * dollars.to_f).to_i
  end

  class << self
    def split_between_two_people(payer, ower, attrs = {})
      expense = Expense.new(attrs)
      half_amount = expense.amount_paid.to_f / 2
      if half_amount % 1 == 0 then
        expense.person_expenses.new(person: ower, amount: -half_amount)
        expense.person_expenses.new(person: payer, amount: half_amount)
      else
        if rand() <= 0.5 then
          expense.person_expenses.new(person: ower, amount: -half_amount.ceil)
          expense.person_expenses.new(person: payer, amount: half_amount.floor)
        else
          expense.person_expenses.new(person: ower, amount: -half_amount.floor)
          expense.person_expenses.new(person: payer, amount: half_amount.ceil)
        end
      end
      expense
    end
    def find_between_two_people(first_person, second_person)
      Expense.joins("JOIN person_expenses AS pe1 ON expenses.id = pe1.expense_id").
        joins("JOIN person_expenses AS pe2 ON expenses.id = pe2.expense_id").
        where("pe1.person_id = ? AND pe2.person_id = ?", first_person, second_person)
    end
  end

  private
    def amounts_sum_to_amount_paid
      amount_sum = self.person_expenses.inject(0) do |cumulative_sum, person_expense|
        cumulative_sum + person_expense.try(&:amount).to_i.abs
      end
      if amount_sum != self.amount_paid
        self.errors.add(:dollar_amount_paid, "should be the sum of the amounts split between people")
      end
    end

    def amounts_sum_to_near_zero
      amount_sum = self.person_expenses.inject(0) do |cumulative_sum, person_expense|
        cumulative_sum + person_expense.try(&:amount).to_i
      end
      if amount_sum < -1 or amount_sum > 1
        self.errors.add(:person_expenses, "amounts should sum to zero")
      end
    end
end
