class Post < ApplicationRecord

  has_one_attached :image
  validate :image_presence
  belongs_to :user

  validates :name, :address, :score, presence: true
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  geocoded_by :address
  after_validation :geocode

  def image_presence
    unless image.attached?
      errors.add(:image ,"を添付してください")
    end
  end

end