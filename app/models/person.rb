class Person < ApplicationRecord
  has_many :person_expenses, dependent: :destroy
  has_many :expenses, through: :person_expenses, dependent: :destroy

  validates :name, presence: true
end
