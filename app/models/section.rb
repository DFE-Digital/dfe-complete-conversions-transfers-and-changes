class Section < ApplicationRecord
  belongs_to :project
  has_many :tasks
end
