class Expense < ApplicationRecord
  has_many :person_expenses, -> { includes :person }
  has_many :people, through: :person_expenses

  validates :amount_paid, presence: true
  validates :person_expenses, length: { minimum: 2 }

  # class << self
  # end

  # private
end
