class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :creator, presence: true
  validates :code, uniqueness: true, allow_nil: true

  has_many :project_photos, dependent: :destroy
  has_many :project_map_links, dependent: :destroy
  has_many :project_design_links, dependent: :destroy
  has_many :project_reference_links, dependent: :destroy
  has_many :project_files, dependent: :destroy
  has_many :content_plan_items, dependent: :destroy

  # Many-to-many relationship with users as specialists
  has_many :project_specialists, dependent: :destroy
  has_many :specialists, through: :project_specialists, source: :user

  accepts_nested_attributes_for :project_photos, allow_destroy: true
  accepts_nested_attributes_for :project_map_links, allow_destroy: true
  accepts_nested_attributes_for :project_design_links, allow_destroy: true
  accepts_nested_attributes_for :project_reference_links, allow_destroy: true
  accepts_nested_attributes_for :project_files, allow_destroy: true
  accepts_nested_attributes_for :content_plan_items, allow_destroy: true

  # Code generation and management
  def generate_code!
    loop do
      new_code = 5.times.map { rand(10) }.join
      if self.class.where(code: new_code).where.not(id: id).empty?
        self.code = new_code
        self.expire_in = 1.day.from_now
        break
      end
    end
  end

  def code_expired?
    expire_in.present? && expire_in < Date.current
  end

  def code_valid?
    code.present? && !code_expired?
  end

  def ensure_valid_code!
    if code.blank? || code_expired?
      generate_code!
      save!
    end
  end

  # Find project by valid code
  def self.find_by_valid_code(code)
    project = find_by(code: code)
    return nil unless project
    return nil if project.code_expired?
    project
  end
end
