class TaskList::CheckBoxAction < ViewComponent::Base
  def initialize(task:, attribute:)
    @attribute = attribute
    @locales_path = task.locales_path
    @label = label
    @hint = hint
    @guidance_link = guidance_link
    @guidance = guidance
    @task = task
    @name = "#{@task.class.name.parameterize(separator: "_")}[#{@attribute}]"
  end

  private def label
    t("#{@locales_path}.#{@attribute}.title")
  end

  private def hint
    t("#{@locales_path}.#{@attribute}.hint.html", default: nil)
  end

  private def guidance_link
    t("#{@locales_path}.#{@attribute}.guidance_link", default: nil)
  end

  private def guidance
    t("#{@locales_path}.#{@attribute}.guidance.html", default: nil)
  end
end
