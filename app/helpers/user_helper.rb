module UserHelper
  def last_seen_datetime(user)
    return "N/A" unless user.active
    return "N/A" if user.latest_session.nil?
    user.latest_session.to_formatted_s(:govuk_date_time)
  end
end
