class Conversion::Voluntary::TaskList < ApplicationRecord
  belongs_to :project, inverse_of: :task_list

  Tasks = [
    Conversion::Voluntary::LandQuestionnaire,
    Conversion::Voluntary::SupplementalFundingAgreement
  ].freeze

  Tasks.each do |task|
    task_instance = task.new

    mapping = task_instance.attributes.keys.map do |attribute|
      ["#{task.key}_#{attribute}", attribute]
    end

    composed_of \
      task.key.to_sym,
      class_name: task.name,
      mapping: mapping,
      constructor: :compose
  end

  def tasks
    Tasks
  end
end
