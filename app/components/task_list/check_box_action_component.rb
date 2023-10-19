class TaskList::CheckBoxActionComponent < ViewComponent::Base
  def initialize(task:, attribute:)
    locales_path = task.locales_path

    @task = task
    @attribute = attribute
    @label = I18n.t("#{locales_path}.#{attribute}.title")
    @hint = I18n.t("#{locales_path}.#{attribute}.hint.html", default: nil)
    @guidance_link = I18n.t("#{locales_path}.#{attribute}.guidance_link", default: nil)
    @guidance = I18n.t("#{locales_path}.#{attribute}.guidance.html", default: nil)
    @action_id = "#{task.class.name.underscore.tr("/", "_")}[#{attribute}]"
  end

  def check_box_value
    @task.public_send(@attribute)
  end
end
