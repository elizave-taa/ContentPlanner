class User < ApplicationRecord
  has_secure_password
  has_many :projects, foreign_key: :creator_id, dependent: :destroy
end
