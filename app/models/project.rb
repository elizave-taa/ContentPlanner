class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :creator, presence: true
  validates :website_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :map_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

  has_many :project_photos, dependent: :destroy
  has_many :project_map_links, dependent: :destroy
  has_many :project_design_links, dependent: :destroy
  has_many :project_reference_links, dependent: :destroy
  has_many :project_files, dependent: :destroy
end
