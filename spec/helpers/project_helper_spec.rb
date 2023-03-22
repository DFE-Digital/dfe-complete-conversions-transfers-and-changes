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
        project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false)

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

  describe "#all_conditions_met_tag" do
    context "when all_conditions_met is true" do
      let(:task_list) { create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: true) }
      let(:project) { build(:conversion_project, task_list: task_list) }

      it "returns a turquoise tag with 'yes' text" do
        expect(helper.all_conditions_met_tag(project)).to include("turquoise", "yes")
      end
    end

    context "when all_conditions_met is false" do
      let(:task_list) { create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: nil) }
      let(:project) { build(:conversion_project, task_list: task_list) }

      it "returns a blue tag with 'not started' text" do
        expect(helper.all_conditions_met_tag(project)).to include("blue", "not started")
      end
    end
  end

  describe "#address_markup" do
    context "within school details" do
      it "returns the address on mutiple lines wrapped in the <address> tag" do
        establishment = build(:academies_api_establishment)
        markup = address_markup(establishment.address)

        expect(markup).to include("address")
        expect(markup).to include("/address")
        expect(markup).to include("#{establishment.address_street}<br/>")
        expect(markup).to include("#{establishment.address_additional}<br/>")
        expect(markup).to include(establishment.address_postcode.to_s)
      end
    end

    context "within trust details" do
      it "returns the address on mutiple lines wrapped in the <address> tag" do
        trust = build(:academies_api_trust)
        markup = address_markup(trust.address)

        expect(markup).to include("address")
        expect(markup).to include("/address")
        expect(markup).to include("#{trust.address_street}<br/>")
        expect(markup).to include("#{trust.address_additional}<br/>")
        expect(markup).to include(trust.address_postcode.to_s)
      end
    end
  end

  describe "#completed_project_notification_banner" do
    context "when the project is not complete i.e. in-progress" do
      it "does nothing" do
        project = build(:conversion_project, completed_at: nil)

        expect(completed_project_notification_banner(project)).to be_nil
      end
    end

    context "when the project is completed" do
      it "renders the notification banner" do
        project = build(:conversion_project, completed_at: Date.yesterday)

        expect(completed_project_notification_banner(project))
          .to include("Project completed")
      end
    end
  end
end
