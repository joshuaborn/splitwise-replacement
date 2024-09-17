class Person < ApplicationRecord
  has_many :payer_transactions, class_name: "Transaction", foreign_key: "payer_id", dependent: :destroy
  has_many :ower_transactions, class_name: "Transaction", foreign_key: "ower_id", dependent: :destroy

  validates :name, presence: true

  def transactions
    Transaction.find_for_person(self)
  end
end
