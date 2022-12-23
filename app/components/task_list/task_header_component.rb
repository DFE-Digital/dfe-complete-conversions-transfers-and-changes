class TaskList::TaskHeaderComponent < ViewComponent::Base
  def initialize(project:, task:)
    locales_path = task.locales_path
    @establishment_name = project.establishment.name
    @title = t("#{locales_path}.title")
    @hint = t("#{locales_path}.hint.html", default: nil)
    @guidance_link = t("#{locales_path}.guidance_link", default: nil)
    @guidance = t("#{locales_path}.guidance.html", default: nil)
  end
end
