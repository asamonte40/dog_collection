class Breed < ApplicationRecord
  has_many :dogs, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, :temperament, :life_span, :image_url, presence: true, allow_blank: true
end
