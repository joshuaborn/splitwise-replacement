class Transaction < ApplicationRecord
  belongs_to :first_person, class_name: "Person"
  belongs_to :second_person, class_name: "Person"

  validates :first_person, presence: true
  validates :second_person, presence: true
  validates :amount_paid, presence: true
  validates :amount_lent, presence: true
  validates :absolute_amount_lent, numericality: { less_than_or_equal_to: :absolute_amount_paid }
  validates :second_person_id, numericality: { greater_than: :first_person_id }

  def absolute_amount_paid
    self.amount_paid.abs()
  end

  def absolute_amount_lent
    self.amount_lent.abs()
  end

  class << self
    def find_for_person(person)
      Transaction.where(first_person: person).or(Transaction.where(second_person: person))
    end
  end
end
