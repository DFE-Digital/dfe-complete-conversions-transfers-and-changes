module AssignmentsHelper
  def full_name_and_email(user)
    "#{user.full_name} (#{user.email})"
  end
end
