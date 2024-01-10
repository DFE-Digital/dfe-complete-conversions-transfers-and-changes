class SplitConversionGrantCertificateCheckAndSaveTask < ActiveRecord::Migration[7.0]
  def up
    rename_column :conversion_tasks_data, :receive_grant_payment_certificate_check_and_save, :receive_grant_payment_certificate_save_certificate
    add_column :conversion_tasks_data, :receive_grant_payment_certificate_check_certificate, :boolean

    Conversion::Project.all do |project|
      tasks_data = project.tasks_data
      next unless tasks_data
      tasks_data.receive_grant_payment_certificate_check_certificate = tasks_data.receive_grant_payment_certificate_save_certificate
      tasks_data.save(validate: false)
    end
  end

  def down
    rename_column :conversion_tasks_data, :receive_grant_payment_certificate_save_certificate, :receive_grant_payment_certificate_check_and_save
    remove_column :conversion_tasks_data, :receive_grant_payment_certificate_check_certificate
  end
end
