class Dog < ApplicationRecord
  belongs_to :breed
  belongs_to :owner

    validates :name, :image_url, presence: true
end
