class Transfer::TasksData < ActiveRecord::Base
  include TasksDatable

  self.table_name = "transfer_tasks_data"

  def self.policy_class
    TaskListPolicy
  end

  enum :sponsored_support_grant_type,
    {
      standard: "standard",
      fast_track: "fast_track",
      intermediate: "intermediate",
      full_sponsored: "full_sponsored"
    }
end
