class TaskList::CheckBoxActionComponent < ViewComponent::Base
  def initialize(task:, attribute:)
    locales_path = task.locales_path

    @task = task
    @attribute = attribute
    @label = t("#{locales_path}.#{attribute}.title")
    @hint = t("#{locales_path}.#{attribute}.hint.html", default: nil)
    @guidance_link = t("#{locales_path}.#{attribute}.guidance_link", default: nil)
    @guidance = t("#{locales_path}.#{attribute}.guidance.html", default: nil)
    @action_id = "#{task.class.name.underscore.tr("/", "_")}[#{attribute}]"
  end

  def check_box_value
    @task.send(@attribute)
  end
end
