class Capability < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :description, presence: true

  def self.manage_team
    find_or_create_by(
      name: :manage_team,
      description: "Capabilities dependent on the User#manage_team attribute"
    )
  end

  def self.add_new_project
    find_or_create_by(
      name: :add_new_project,
      description: "Capabilities dependent on the User#add_new_project attribute"
    )
  end

  def self.assign_to_project
    find_or_create_by(
      name: :assign_to_project,
      description: "Capabilities dependent on the User#assign_to_project attribute"
    )
  end
end
