class PersonExpense < ApplicationRecord
  belongs_to :person
  belongs_to :expense

  validates :person, presence: true
  validates :expense, presence: true
end
