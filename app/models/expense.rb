class Expense < ApplicationRecord
  has_many :person_expenses, -> { includes :person }, dependent: :destroy
  has_many :people, through: :person_expenses

  validates :amount_paid, presence: true
  validates :person_expenses, length: { minimum: 2 }
  validates_associated :person_expenses

  def dollar_amount_paid
    self.amount_paid.to_f / 100
  end

  def dollar_amount_paid=(dollars)
    self.amount_paid = (100 * dollars).to_i
  end
  # class << self
  # end

  # private
end
