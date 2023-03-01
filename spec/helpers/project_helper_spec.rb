require "rails_helper"

RSpec.describe ProjectHelper, type: :helper do
  describe "#age_range" do
    context "when the lower age range is nil" do
      let(:establishment) { build(:academies_api_establishment, age_range_lower: nil) }

      it "returns nil" do
        expect(helper.age_range(establishment)).to be_nil
      end
    end

    context "when the upper age range is nil" do
      let(:establishment) { build(:academies_api_establishment, age_range_upper: nil) }

      it "returns nil" do
        expect(helper.age_range(establishment)).to be_nil
      end
    end

    context "when both upper and lower ranges have values" do
      let(:establishment) { build(:academies_api_establishment) }

      it "returns a formatted date range" do
        expect(helper.age_range(establishment)).to eq "11 to 18"
      end
    end
  end

  describe "#display_name" do
    subject { helper.display_name(user) }

    context "when user is nil" do
      let(:user) { nil }

      it "returns a 'Not yet assigned' message" do
        expect(subject).to eq t("project_information.show.project_details.rows.unassigned")
      end
    end

    context "when full name is present" do
      let(:user) { build(:user) }

      it "returns the full name" do
        expect(subject).to eq "John Doe"
      end
    end
  end

  describe "#mail_to_path" do
    subject { helper.mail_to_path("john.doe@education.gov.uk") }

    it "returns a `mailto` path (not wrapped in a link)" do
      expect(subject).to eq "mailto:john.doe@education.gov.uk"
    end
  end

  describe "#converting_on_date" do
    context "when the conversion date is provisional" do
      it "returns the formatted date and a provisional tag" do
        project = build(:conversion_project)

        expect(helper.converting_on_date(project)).to include project.provisional_conversion_date.to_formatted_s(:govuk)
        expect(helper.converting_on_date(project)).to include "provisional"
      end
    end

    context "when the conversion date is confirmed" do
      it "returns the formatted date and a provisional tag" do
        project = build(:conversion_project, conversion_date: Date.today)

        expect(helper.converting_on_date(project)).to include project.conversion_date.to_formatted_s(:govuk)
        expect(helper.converting_on_date(project)).not_to include "provisional"
      end
    end
  end

  describe "#link_to_school_on_gias" do
    context "when a urn is provided" do
      let(:urn) { "12345" }

      it "returns a link to the school on gias" do
        expect(link_to_school_on_gias(urn)).to include("https://get-information-schools.service.gov.uk/Establishments/Establishment/Details/#{urn}")
      end

      it "opens the link in a new tab" do
        expect(link_to_school_on_gias(urn)).to include("_blank")
      end
    end

    context "when a urn is not provided" do
      let(:urn) { nil }

      it "returns an argument error" do
        expect { link_to_school_on_gias(urn) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#link_to_trust_on_gias" do
    context "when a ukprn is provided" do
      let(:ukprn) { "101456" }

      it "returns a link to the trust on gias" do
        expect(link_to_trust_on_gias(ukprn)).to include("https://get-information-schools.service.gov.uk/Groups/Search?GroupSearchModel.Text=#{ukprn}")
      end

      it "opens the link in a new tab" do
        expect(link_to_trust_on_gias(ukprn)).to include("_blank")
      end
    end

    context "when a ukprn is not provided" do
      let(:ukprn) { nil }

      it "returns an argument error" do
        expect { link_to_trust_on_gias(ukprn) }.to raise_error(ArgumentError)
      end
    end
  end
end
