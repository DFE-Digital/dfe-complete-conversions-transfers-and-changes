require "rails_helper"

RSpec.describe ExistingAcademyValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :urn
      validates :urn, existing_academy: true
    }.new
  end

  context "with the URN of an academy type establishment" do
    it "is invalid" do
      _establishment = create(:gias_establishment, urn: 123456, type_code: "42")

      subject.urn = 123456
      expect(subject.valid?).to be false
    end
  end

  context "with the URN of a non-academy establishment" do
    it "is valid" do
      _establishment = create(:gias_establishment, urn: 123456, type_code: "02")

      subject.urn = 123456
      expect(subject.valid?).to be true
    end
  end
end
