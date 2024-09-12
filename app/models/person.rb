class Person < ApplicationRecord
  has_many :payer_transactions, class_name: "Transaction", foreign_key: "payer_id"
  has_many :ower_transactions, class_name: "Transaction", foreign_key: "ower_id"

  validates :name, presence: true
end
