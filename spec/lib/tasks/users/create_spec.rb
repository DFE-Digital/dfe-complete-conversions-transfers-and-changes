require "rails_helper"

RSpec.describe "rake users:create", type: :task do
  it "creates a user in the service" do
    ClimateControl.modify(EMAIL_ADDRESS: "name@example.com") do
      expect { Rake::Task["users:create"].execute }.to change { User.count }.by(1)
      expect(User.last.email).to eq "name@example.com"
    end
  end

  it "does not create duplicates" do
    User.create(email: "name@example.com")

    ClimateControl.modify(EMAIL_ADDRESS: "name@example.com") do
      expect { Rake::Task["users:create"].execute }
        .to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  it "errors if no email address is supplied" do
    expect { Rake::Task["users:create"].invoke }
      .to raise_error(SystemExit, I18n.t("tasks.users.create.error"))
  end
end
