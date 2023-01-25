class ConversionInvoluntaryTaskGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_files
    copy_file "view.html.erb", "app/views/conversion/involuntary/task_lists/tasks/#{file_name}.html.erb"
    copy_file "locales.en.yml", "config/locales/task_lists/conversion/involuntary/#{file_name}.en.yml"
    copy_file "model.rb", "app/models/conversion/involuntary/tasks/#{file_name}.rb"
  end

  def gsub_files
    gsub_file "app/models/conversion/involuntary/tasks/#{file_name}.rb", "TaskName", class_name.to_s
    gsub_file "config/locales/task_lists/conversion/involuntary/#{file_name}.en.yml", "name_of_task:", "#{file_name}:"
  end

  def generate_migration
    generate "migration", "AddInvoluntary#{class_name}Task"
  end
end
