namespace :users do
  desc ">> Import a list of users email addresses who can sign in to the service"
  task create: :environment do
    email_address = ENV["EMAIL_ADDRESS"]

    abort I18n.t("tasks.users.create.error") if email_address.nil?

    User.create!(email: email_address)
  end
end
