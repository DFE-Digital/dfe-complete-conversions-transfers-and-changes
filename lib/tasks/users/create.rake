namespace :users do
  desc ">> Import a list of users email addresses who can sign in to the service"
  task :create, [:email, :first_name, :last_name] => :environment do |_task, args|
    abort I18n.t("tasks.users.create.error") if args.names.any? { |name| args[name].nil? }

    User.create!(args.to_h)
  end
end
