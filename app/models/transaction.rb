class Transaction < ApplicationRecord
  belongs_to :first_person, class_name: "Person"
  belongs_to :second_person, class_name: "Person"

  validates :first_person, presence: true
  validates :second_person, presence: true
  validates :amount_paid, presence: true
  validates :amount_lent, presence: true
  validates :absolute_amount_lent, numericality: { less_than_or_equal_to: :absolute_amount_paid }
  validates :second_person_id, numericality: { greater_than: :first_person_id }

  before_validation :ensure_order_of_associated_people

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

    def find_for_people(first_person, second_person)
      if first_person.id > second_person.id then
        Transaction.where(
          first_person: second_person,
          second_person: first_person
        ).all
      else
        Transaction.where(
          first_person: first_person,
          second_person: second_person
        ).all
      end
    end
  end

  private
    def ensure_order_of_associated_people
      if self.first_person.id > self.second_person.id then
        old_first_person = self.first_person
        self.first_person = self.second_person
        self.second_person = old_first_person
      end
    end
end
