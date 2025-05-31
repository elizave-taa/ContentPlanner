class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :creator, presence: true

  has_many :project_photos, dependent: :destroy
  has_many :project_map_links, dependent: :destroy
  has_many :project_design_links, dependent: :destroy
  has_many :project_reference_links, dependent: :destroy
  has_many :project_files, dependent: :destroy

  accepts_nested_attributes_for :project_photos, allow_destroy: true
  accepts_nested_attributes_for :project_map_links, allow_destroy: true
  accepts_nested_attributes_for :project_design_links, allow_destroy: true
  accepts_nested_attributes_for :project_reference_links, allow_destroy: true
  accepts_nested_attributes_for :project_files, allow_destroy: true
end
