class Person < ApplicationRecord
  has_many :person_expenses, -> { includes :expense }
  has_many :expenses, through: :person_expenses

  validates :name, presence: true
end
