require "rails_helper"

RSpec.describe DateHistory::Reasons::BaseForm, type: :model do
  describe "sub classes" do
    it "must implement reasons_list" do
      form = DateHistory::Reasons::TestForm.new

      expect { form.reasons_list }.to raise_error("You must implement reason_list")
    end
  end
end

class DateHistory::Reasons::TestForm < DateHistory::Reasons::BaseForm
end
