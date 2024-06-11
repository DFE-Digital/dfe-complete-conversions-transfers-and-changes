class SignificantDatePresenter < SimpleDelegator
  def title
    created_at.to_fs(:govuk_date_time)
  end

  def user_email
    user.email
  end

  def to_date
    revised_date.to_fs(:govuk)
  end

  def from_date
    previous_date.to_fs(:govuk)
  end
end
