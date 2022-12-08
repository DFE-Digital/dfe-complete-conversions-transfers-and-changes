class Conversion::Voluntary::TaskList < ApplicationRecord
  belongs_to :project, inverse_of: :task_list

  TASKS = [
    Conversion::Voluntary::LandQuestionnaire,
    Conversion::Voluntary::SupplementalFundingAgreement
  ].freeze

  TASKS.each do |task|
    mapping = task.attribute_names.map do |attribute|
      ["#{task.key}_#{attribute}", attribute]
    end

    composed_of \
      task.key.to_sym,
      class_name: task.name,
      mapping:,
      constructor: :compose
  end

  def load
    SECTIONS.deep_dup.each do |section|
      section.tasks = load_tasks(section)
    end
  end

  private def load_tasks(section)
    section.tasks.map do |task|
      attributes_for_task = attributes
                              .select { |key| key.start_with?(task.key) }
                              .transform_keys { |key| key.sub("#{task.key}_", "") }

      task.new(attributes_for_task)
    end
  end
end
