require "rails_helper"
# We don't want to ship any code that cannot be eager loaded in Prouction so we
# this check to the test suite
#
# https://guides.rubyonrails.org/testing.html#bare-test-suites

RSpec.describe "Zeitwerk compliance" do
  it "eager loads all files without errors" do
    expect { Rails.application.eager_load! }.not_to raise_error
  end
end
