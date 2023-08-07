class Conversion::TasksData < ActiveRecord::Base
  include TasksDatable

  self.table_name = "conversion_tasks_data"

  def self.policy_class
    TaskListPolicy
  end

  enum :sponsored_support_grant_type,
    {
      fast_track: "fast_track",
      intermediate: "intermediate",
      full_sponsored: "full_sponsored"
    }
end
