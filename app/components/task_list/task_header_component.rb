class TaskList::TaskHeaderComponent < ViewComponent::Base
  def initialize(project:, task:)
    locales_path = task.locales_path
    @establishment_name = project.establishment.name
    @title = I18n.t("#{locales_path}.title")
    @hint = I18n.t("#{locales_path}.hint.html", default: nil)
    @guidance_link = I18n.t("#{locales_path}.guidance_link", default: nil)
    @guidance = I18n.t("#{locales_path}.guidance.html", default: nil)
  end
end
