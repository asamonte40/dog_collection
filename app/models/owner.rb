class Owner < ApplicationRecord
  has_many :dogs, dependent: :destroy
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
