class Event < ApplicationRecord
  belongs_to :user
  belongs_to :eventable, polymorphic: true, optional: true

  enum :grouping, {
    system: 0,
    project: 1
  }, default: :system

  class << self
    def log(grouping:, user:, message:, with: nil)
      unless groupings.key?(grouping.to_s)
        raise ArgumentError
          .new("Events grouping must be one of #{groupings.keys.to_sentence(two_words_connector: " or ")}.")
      end

      case grouping
      when :project
        raise ArgumentError.new("You must pass a Project as `with` for the project grouping.") unless with.is_a?(Project)

        create!(user: user, message: message, eventable: with, grouping: :project)
      else
        create!(user: user, message: message, grouping: :system)
      end
    end
  end
end
