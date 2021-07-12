class Music < ApplicationRecord
  has_many :charts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }
end
