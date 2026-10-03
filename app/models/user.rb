class User < ApplicationRecord
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..20 }
 
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
 
  validates :password, presence: true,
                       length: { in: 6..16 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy  
end
