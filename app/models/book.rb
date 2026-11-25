class Book < ApplicationRecord
  belongs_to :author

  validates :isbn, presence: true, uniqueness: true
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def decrement_stock!(quantity = 1)
    raise StandardError, "Insufficient stock" if stock_quantity < quantity

    update!(stock_quantity: stock_quantity - quantity)
  end
end
