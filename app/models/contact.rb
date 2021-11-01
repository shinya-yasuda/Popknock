class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :message, presence: true
  validates :category, presence: true
  enum category: { report_error: 0, question: 1, request: 2, other: 3 }
end
