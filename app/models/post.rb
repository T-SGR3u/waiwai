class Post < ApplicationRecord

  # validate :image_presence
  belongs_to :user 
  has_many :comments
  has_many :images ,dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, :address, :score, presence: true
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  geocoded_by :address
  after_validation :geocode

end