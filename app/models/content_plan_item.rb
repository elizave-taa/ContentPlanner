class ContentPlanItem < ApplicationRecord
  belongs_to :project

  # Platform enum matching the social platforms from projects
  enum platform: {
    telegram: 0,
    instagram: 1,
    vkontakte: 2,
    youtube: 3,
    tiktok: 4,
    yandex_zen: 5
  }

  # Validations
  validates :title, presence: true
  validates :platform, presence: true
  validates :posted, inclusion: { in: [true, false] }

  # Scope methods
  scope :posted, -> { where(posted: true) }
  scope :unposted, -> { where(posted: false) }
  scope :by_platform, ->(platform) { where(platform: platform) }
  scope :due_before, ->(date) { where('deadline <= ?', date) }
  scope :overdue, -> { where('deadline < ? AND posted = ?', Date.current, false) }

  # Instance methods
  def overdue?
    deadline.present? && deadline < Date.current && !posted?
  end

  def due_today?
    deadline == Date.current
  end

  def platform_name
    case platform
    when 'telegram' then 'Telegram'
    when 'instagram' then 'Instagram'
    when 'vkontakte' then 'ВКонтакте'
    when 'youtube' then 'YouTube'
    when 'tiktok' then 'TikTok'
    when 'yandex_zen' then 'Яндекс Дзен'
    else platform.humanize
    end
  end
end
