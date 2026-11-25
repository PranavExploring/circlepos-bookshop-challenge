require "rails_helper"

RSpec.describe "Api::V1::Books", type: :request do
  let!(:author) { Author.create!(name: "Fyodor Dostoevsky") }
  let!(:book) do
    Book.create!(
      author: author,
      isbn: "9780140449136",
      title: "Crime and Punishment",
      price: 24.99,
      stock_quantity: 5
    )
  end

  describe "GET /api/v1/books" do
    it "returns all books with author details" do
      get "/api/v1/books"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(1)
      expect(body.first.dig("author", "name")).to eq("Fyodor Dostoevsky")
    end
  end

  describe "POST /api/v1/books/:id/sell" do
    it "decrements stock quantity on sale" do
      post "/api/v1/books/#{book.id}/sell", params: { quantity: 2 }
      expect(response).to have_http_status(:ok)
      expect(book.reload.stock_quantity).to eq(3)
    end

    it "returns an error when stock is insufficient" do
      post "/api/v1/books/#{book.id}/sell", params: { quantity: 10 }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
