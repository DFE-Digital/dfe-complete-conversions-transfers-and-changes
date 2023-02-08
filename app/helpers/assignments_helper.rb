module AssignmentsHelper
  def full_name_and_email(user)
    "#{user.full_name} (#{user.email})"
  end

  def all_eligible_users
    [User.caseworkers, User.regional_delivery_officers, User.team_leaders].flatten.uniq
  end
end
