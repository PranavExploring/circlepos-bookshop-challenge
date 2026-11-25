module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[show update destroy sell]

      def index
        books = Book.includes(:author).all
        if params[:q].present?
          books = books.joins(:author).where(
            "books.title LIKE :q OR books.isbn LIKE :q OR authors.name LIKE :q",
            q: "%#{params[:q]}%"
          )
        end
        render json: books.as_json(include: { author: { only: %i[id name] } }), status: :ok
      end

      def show
        render json: @book.as_json(include: { author: { only: %i[id name] } }), status: :ok
      end

      def create
        book = Book.new(book_params)
        if book.save
          render json: book.as_json(include: { author: { only: %i[id name] } }), status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render json: @book.as_json(include: { author: { only: %i[id name] } }), status: :ok
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @book.destroy
        head :no_content
      end

      def sell
        book = PosCheckoutService.new(book: @book, quantity: params[:quantity] || 1).call
        render json: { message: "Sale recorded", book: book }, status: :ok
      rescue PosCheckoutService::OutOfStockError, ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def set_book
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Book not found" }, status: :not_found
      end

      def book_params
        params.require(:book).permit(:author_id, :isbn, :title, :price, :stock_quantity)
      end
    end
  end
end
