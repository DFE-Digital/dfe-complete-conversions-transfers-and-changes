class Conversion::Details < ApplicationRecord
  self.table_name = "conversion_project_details"
  belongs_to :project
end
