class User < ApplicationRecord
  has_secure_password
  has_many :projects, foreign_key: :creator_id, dependent: :destroy

  # Many-to-many relationship with projects as specialist
  has_many :project_specialists, dependent: :destroy
  has_many :specialist_projects, through: :project_specialists, source: :project
end
