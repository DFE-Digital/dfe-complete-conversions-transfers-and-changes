class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  def route
    return :voluntary if task_list_type == "Conversion::Voluntary::TaskList"
    return :involuntary if task_list_type == "Conversion::Involuntary::TaskList"
  end

  def conversion_date
    if task_list_type == "Conversion::Voluntary::TaskList"
      if task_list.stakeholder_kick_off_confirmed_conversion_date.present?
        return ConversionDate.new(date: task_list.stakeholder_kick_off_confirmed_conversion_date, provisional: false)
      end
    end

    ConversionDate.new(date: provisional_conversion_date, provisional: true)
  end

  class ConversionDate
    attr_reader :date

    def initialize(date:, provisional:)
      @date = date
      @provisional = provisional
    end

    def provisional?
      @provisional
    end
  end
end
