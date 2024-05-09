namespace :api_key do
  desc ">> Generate an Api key for the application"
  task :generate, [:description] => :environment do |_task, args|
    abort "Please supply a brief description of who this key is for, e.g. api_key:generate['Key for Prepare application']" if args[:description].nil?

    key = ApiKey.new(api_key: SecureRandom.uuid, expires_at: Date.today + 3.years, description: args[:description])
    if key.save
      puts "New key generated: #{key.api_key}"
    end
  end
end
