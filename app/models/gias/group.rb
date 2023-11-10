class Gias::Group < ApplicationRecord
  self.table_name = :gias_groups

  validates :unique_group_identifier, presence: true
end
