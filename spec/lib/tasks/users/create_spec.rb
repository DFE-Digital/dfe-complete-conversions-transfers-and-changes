require "rails_helper"

RSpec.describe "rake users:create", type: :task do
  let(:email) { "john.doe@education.gov.uk" }
  let(:first_name) { "John" }
  let(:last_name) { "Doe" }

  subject { Rake::Task["users:create"] }

  after { subject.reenable }

  describe "missing arguments" do
    %w[email first_name last_name].each do |attribute|
      context "when #{attribute} is not provided" do
        let(:"#{attribute}") { nil }

        it "aborts the task" do
          expect { subject.invoke(email, first_name, last_name) }.to raise_error(SystemExit, I18n.t("tasks.users.create.error"))
        end
      end
    end
  end

  it "creates a user in the service" do
    expect { subject.invoke(email, first_name, last_name) }.to change { User.count }.by(1)
    expect(User.last).to have_attributes(first_name:, last_name:, email:)
  end

  context "when the user already exists" do
    let!(:user) { create(:user, email: email) }

    it "does not create a duplicate" do
      expect { subject.invoke(email, first_name, last_name) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
