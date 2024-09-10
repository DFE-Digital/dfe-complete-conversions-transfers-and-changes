module SignificantDate
  extend ActiveSupport::Concern

  included do
    has_many :significant_dates, dependent: :destroy, class_name: "SignificantDateHistory"

    validates :significant_date, first_day_of_month: true

    scope :provisional, -> { where(significant_date_provisional: true) }
    scope :confirmed, -> { where(significant_date_provisional: false) }
    scope :ordered_by_significant_date, -> { order(significant_date: :asc) }
    scope :filtered_by_significant_date, ->(month, year) { where("MONTH(significant_date) = ?", month).and(where("YEAR(significant_date) = ?", year)) }

    def provisional_date
      return significant_date if significant_dates.empty?

      significant_dates.order(:created_at).first.previous_date
    end

    def confirmed_date_and_in_the_past?
      !significant_date_provisional? && significant_date.past?
    end
  end

  class_methods do
    def significant_date_revised_from(month, year)
      projects = in_progress.confirmed

      latest_date_histories = SignificantDateHistory.group(:project_id).having("COUNT(created_at) > 1").maximum(:created_at)

      matching_date_histories = SignificantDateHistory
        .where(project_id: latest_date_histories.keys)
        .where(created_at: latest_date_histories.values)
        .to_sql

      projects.joins("INNER JOIN (#{matching_date_histories}) AS date_history ON date_history.project_id = projects.id")
        .where("date_history.previous_date != date_history.revised_date")
        .where("MONTH(date_history.previous_date) = ?", month)
        .where("YEAR(date_history.previous_date) = ?", year)
        .ordered_by_significant_date
    end

    def significant_date_in_range(from_date, to_date)
      where(significant_date: from_date.at_beginning_of_month..to_date.at_end_of_month).ordered_by_significant_date
    end
  end
end
