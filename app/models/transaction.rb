class Transaction < ApplicationRecord
  belongs_to :payer, class_name: "Person"
  belongs_to :ower, class_name: "Person"

  validates :payer, presence: true
  validates :ower, presence: true
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_lent, numericality: { less_than_or_equal_to: :amount_paid }

  class << self
    def find_for_person(person)
      Transaction.where(ower: person).or(Transaction.where(payer: person)).order(date: :desc)
    end
  end
end
