class ProjectPresenter < SimpleDelegator
  def advisory_board_date
    return if super.blank?

    super.to_date.to_formatted_s(:govuk)
  end
end
