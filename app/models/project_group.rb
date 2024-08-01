class ProjectGroup < ApplicationRecord
  has_many :projects, foreign_key: :group_id
end
