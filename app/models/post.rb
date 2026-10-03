class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { in: 1..300 }
  validates :url, presence: true,
                  format: { with: %r{\Ahttps?://\S+\z}i,
                            message: "must start with http:// or https://" }

  has_many :comments, dependent: :destroy
  
end
