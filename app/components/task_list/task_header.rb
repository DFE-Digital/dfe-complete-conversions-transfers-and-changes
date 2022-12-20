class TaskList::TaskHeader < ViewComponent::Base
  def initialize(project:, task:)
    @locales_path = task.locales_path
    @title = title
    @establishment_name = project.establishment.name
    @hint = hint
    @guidance_link = guidance_link
    @guidance = guidance
  end

  private def title
    t("#{@locales_path}.title")
  end

  private def hint
    t("#{@locales_path}.hint.html", default: nil)
  end

  private def guidance_link
    t("#{@locales_path}.guidance_link", default: nil)
  end

  private def guidance
    t("#{@locales_path}.guidance.html", default: nil)
  end
end
