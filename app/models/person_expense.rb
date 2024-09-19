class PersonExpense < ApplicationRecord
  belongs_to :person
  belongs_to :expense

  validates :person, presence: true
  validates :expense, presence: true
  validates :amount, presence: true

  def dollar_amount
    self.amount.to_f / 100
  end

  def dollar_amount=(dollars)
    self.amount = (100 * dollars).to_i
  end
end
