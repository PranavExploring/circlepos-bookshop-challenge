class Author < ApplicationRecord
  has_many :books, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :bio, length: { maximum: 1000 }, allow_blank: true
end
