require "rails_helper"

RSpec.describe "api_key:generate", type: :task do
  subject { Rake::Task["api_key:generate"] }

  it "exits if no description is supplied" do
    expect { subject.execute }.to raise_error(SystemExit, "Please supply a brief description of who this key is for, e.g. api_key:generate['Key for Prepare application']")
  end

  it "generates a new Api key" do
    expect { subject.invoke("Description") }.to change { ApiKey.count }.by(1)
  end
end
