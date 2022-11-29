require "rails_helper"

RSpec.describe Conversion::Project do
  describe "relationships" do
    it { is_expected.to have_one(:details).dependent(:destroy) }
  end
end
