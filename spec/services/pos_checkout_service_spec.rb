require "rails_helper"

RSpec.describe PosCheckoutService do
  let(:author) { Author.create!(name: "Ursula K. Le Guin") }
  let(:book) do
    Book.create!(
      author: author,
      isbn: "9780441478125",
      title: "The Left Hand of Darkness",
      price: 22.50,
      stock_quantity: 4
    )
  end

  describe "#call" do
    it "decrements stock within a database lock" do
      described_class.new(book: book, quantity: 3).call
      expect(book.reload.stock_quantity).to eq(1)
    end

    it "raises OutOfStockError when requested quantity exceeds stock" do
      expect {
        described_class.new(book: book, quantity: 5).call
      }.to raise_error(PosCheckoutService::OutOfStockError, /Insufficient stock/)
      expect(book.reload.stock_quantity).to eq(4)
    end

    it "raises ArgumentError when quantity is zero or negative" do
      expect {
        described_class.new(book: book, quantity: 0).call
      }.to raise_error(ArgumentError)
    end
  end
end
