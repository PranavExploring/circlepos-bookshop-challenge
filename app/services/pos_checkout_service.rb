class PosCheckoutService
  class OutOfStockError < StandardError; end

  def initialize(book:, quantity: 1)
    @book = book
    @quantity = quantity.to_i
  end

  def call
    raise ArgumentError, "Quantity must be greater than zero" if @quantity <= 0

    @book.with_lock do
      raise OutOfStockError, "Insufficient stock for '#{@book.title}'" if @book.stock_quantity < @quantity

      @book.update!(stock_quantity: @book.stock_quantity - @quantity)
    end

    @book
  end
end
