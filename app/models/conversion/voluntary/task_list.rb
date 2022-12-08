class Conversion::Voluntary::TaskList < ApplicationRecord
  belongs_to :project, inverse_of: :task_list

  SECTIONS = [
    TaskList::Section.new(
      tasks: [
        Conversion::Voluntary::LandQuestionnaire,
        Conversion::Voluntary::SupplementalFundingAgreement
      ],
      title: "Clear legal documents")
  ].freeze

  SECTIONS.map(&:tasks).flatten.each do |task|
    mapping = task.attribute_names.map do |attribute|
      ["#{task.key}_#{attribute}", attribute]
    end

    composed_of \
      task.key.to_sym,
      class_name: task.name,
      mapping:,
      constructor: :compose
  end

  def load_tasks
    sections = SECTIONS.deep_dup

    sections.each do |section|
      section.tasks = section.tasks.map do |task|
        attributes_for_task = attributes
                                .select { |key| key.start_with?(task.key) }
                                .transform_keys { |key| key.sub("#{task.key}_", "") }

        task.new(attributes_for_task)
      end
    end

    sections
  end
end
