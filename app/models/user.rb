class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :results, dependent: :destroy
  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  enum role: { general: 0, admin: 1 }
end
