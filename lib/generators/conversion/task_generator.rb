class Conversion::TaskGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_files
    copy_file "edit.html.erb", "app/views/conversions/tasks/#{file_name}/edit.html.erb"
    copy_file "locales.en.yml", "config/locales/conversion/tasks/#{file_name}.en.yml"
    copy_file "form.rb", "app/forms/conversion/task/#{file_name}_task_form.rb"
  end

  def gsub_files
    gsub_file "app/forms/conversion/task/#{file_name}_task_form.rb", "TaskName", "#{class_name}TaskForm"
    gsub_file "config/locales/conversion/tasks/#{file_name}.en.yml", "task_name:", "#{file_name}:"
    gsub_file "app/views/conversions/tasks/#{file_name}/edit.html.erb", "task_title", "conversion.task.#{file_name}.title"
  end

  def generate_migration
    generate "migration", "AddConversion#{class_name}TaskAttributes"
  end
end
