class Schedule < ApplicationRecord
    belongs_to :project

    # Дополнительно: проект «знает» о своём расписании
    # (если нужно, можно добавить в Project: `has_one :schedule`)
    # validates
    validates :project_id, uniqueness: true
    validates :start_date, presence: true
    validates :weekdays,    presence: true
    validate  :weekdays_must_be_valid

    # Удобный список допустимых дней
    WEEKDAYS = %w[
      monday tuesday wednesday thursday friday saturday sunday
    ].freeze

    private

    def weekdays_must_be_valid
      invalid = weekdays - WEEKDAYS
      if invalid.any?
        errors.add :weekdays, "contains invalid days: #{invalid.join(', ')}"
      end
    end
  end
