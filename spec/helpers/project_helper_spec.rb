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

  describe "#significant_date" do
    context "when the significant date is provisional" do
      it "returns the formatted date and a provisional tag" do
        project = build(:conversion_project, conversion_date_provisional: true)

        expect(helper.significant_date(project)).to include project.conversion_date.to_formatted_s(:govuk)
        expect(helper.significant_date(project)).to include "provisional"
      end
    end

    context "when the significant date is confirmed" do
      it "returns the formatted date and a provisional tag" do
        project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false)

        expect(helper.significant_date(project)).to include project.conversion_date.to_formatted_s(:govuk)
        expect(helper.significant_date(project)).not_to include "provisional"
      end
    end

    it "works for transfer dates as well" do
      project = build(:transfer_project, transfer_date: Date.today.at_beginning_of_month, transfer_date_provisional: false)

      expect(helper.significant_date(project)).to include project.transfer_date.to_formatted_s(:govuk)
      expect(helper.significant_date(project)).not_to include "provisional"

      project = build(:transfer_project, transfer_date: Date.today.at_beginning_of_month, transfer_date_provisional: true)

      expect(helper.significant_date(project)).to include project.transfer_date.to_formatted_s(:govuk)
      expect(helper.significant_date(project)).to include "provisional"
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

      it "returns an empty string (for Form a MAT projects)" do
        expect(link_to_trust_on_gias(ukprn)).to eq("")
      end
    end
  end

  describe "#link_to_companies_house" do
    context "when a companies house number is provided" do
      let(:companies_house_number) { "10768218" }

      it "returns a link to the companies house information" do
        expect(link_to_companies_house(companies_house_number)).to include("https://find-and-update.company-information.service.gov.uk/company/#{companies_house_number}")
      end

      it "opens the link in a new tab" do
        expect(link_to_companies_house(companies_house_number)).to include("_blank")
      end
    end

    context "when a companies house number is not provided" do
      let(:companies_house_number) { nil }

      it "returns an argument error" do
        expect { link_to_companies_house(companies_house_number) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#all_conditions_met_value" do
    context "when all_conditions_met is true" do
      let(:project) { build(:conversion_project, all_conditions_met: true) }

      it "returns a turquoise tag with 'yes' text" do
        expect(helper.all_conditions_met_value(project)).to eql "Yes"
      end
    end

    context "when all_conditions_met is false" do
      let(:project) { build(:conversion_project, all_conditions_met: nil) }

      it "returns a blue tag with 'not started' text" do
        expect(helper.all_conditions_met_value(project)).to eql "Not yet"
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

  describe "#project_notification_banner" do
    context "when the project is not complete i.e. in-progress" do
      context "when the project is assigned to the user" do
        it "does nothing" do
          user = build(:user)
          project = build(:conversion_project, completed_at: nil, assigned_to: user)

          expect(project_notification_banner(project, user)).to be_nil
        end
      end

      context "when the project is not assigned to the user but the user is service support" do
        it "does nothing" do
          user = build(:user)
          service_support_user = build(:user, :service_support)
          project = build(:conversion_project, completed_at: nil, assigned_to: user)

          expect(project_notification_banner(project, service_support_user)).to be_nil
        end
      end

      context "when the project is not assigned to the user and the user is not service support" do
        it "renders a notification banner" do
          user = build(:user)
          other_user = build(:user, email: "other.user@education.gov.uk")

          project = build(:conversion_project, completed_at: nil, assigned_to: other_user)

          expect(project_notification_banner(project, user))
            .to include("Not assigned to project")
        end
      end

      context "when the project is not assigned to any user" do
        it "renders a notification banner" do
          user = build(:user)

          project = build(:conversion_project, completed_at: nil, assigned_to: nil)

          expect(project_notification_banner(project, user))
            .to include("Not assigned to project")
        end
      end
    end

    context "when the project is completed" do
      context "when the project is assigned to the user" do
        it "renders the compeleted notification banner" do
          user = build(:user)
          other_user = build(:user, email: "other.user@education.gov.uk")

          project = build(:conversion_project, :completed, assigned_to: other_user)

          expect(project_notification_banner(project, user))
            .to include("Project completed")
        end
      end

      context "when the project is not assigned to the user" do
        it "renders completed notification banner" do
          user = build(:user)
          other_user = build(:user, email: "other.user@education.gov.uk")

          project = build(:conversion_project, :completed, assigned_to: other_user)

          expect(project_notification_banner(project, user))
            .to include("Project completed")
        end
      end
    end
  end

  describe "#academy_name" do
    it "returns the academy name when available" do
      tasks_data = Conversion::TasksData.new(academy_details_name: "New Academy")
      project = build(:conversion_project, tasks_data: tasks_data)

      expect(helper.academy_name(project)).to eql "New Academy"
    end

    it "returns a unconfirmed tag when there is no academy name" do
      project = build(:conversion_project)

      expect(helper.academy_name(project)).to include("grey", "Unconfirmed")
    end
  end

  describe "#confirmed_date_original_date" do
    before { mock_all_academies_api_responses }

    context "when the project date is provisional" do
      it "returns nil" do
        project = build(:conversion_project, significant_date: Date.new(2024, 1, 1), significant_date_provisional: true)

        expect(helper.confirmed_date_original_date(project)).to eq(nil)
      end
    end

    context "when the project date is confirmed and has never changed" do
      it "returns the two dates correctly" do
        project = build(:conversion_project, significant_date: Date.new(2024, 1, 1), significant_date_provisional: false)
        build(:date_history, project: project, previous_date: Date.new(2024, 1, 1), revised_date: Date.new(2024, 1, 1))

        expect(helper.confirmed_date_original_date(project)).to eq("Jan 2024 (Jan 2024)")
      end
    end

    context "when the project date is confirmed and has changed" do
      it "returns the two dates correctly" do
        project = build(:conversion_project, significant_date: Date.new(2024, 5, 1), significant_date_provisional: false)
        create(:date_history, project: project, previous_date: Date.new(2024, 9, 1), revised_date: Date.new(2024, 5, 1))

        expect(helper.confirmed_date_original_date(project)).to eq("May 2024 (Sep 2024)")
      end
    end

    context "when the project date is confirmed and has changed over time" do
      it "returns the two dates correctly" do
        project = build(:conversion_project, significant_date: Date.new(2023, 7, 1), significant_date_provisional: false)

        _provisional_date = create(
          :date_history,
          project: project,
          previous_date: Date.new(2023, 2, 1),
          revised_date: Date.new(2023, 5, 1),
          created_at: Date.new(2023, 1, 1)
        )
        _first_revision = create(
          :date_history,
          project: project,
          previous_date: Date.new(2023, 5, 1),
          revised_date: Date.new(2023, 8, 1),
          created_at: Date.new(2023, 4, 1)
        )
        _second_revision = create(
          :date_history,
          project: project,
          previous_date: Date.new(2023, 8, 1),
          revised_date: Date.new(2023, 7, 1),
          created_at: Date.new(2023, 6, 1)
        )

        expect(helper.confirmed_date_original_date(project)).to eq("Jul 2023 (Feb 2023)")
      end
    end

    context "when the project's significant date is confirmed" do
      context "and unexpectedly has no date history" do
        it "returns the two dates correctly" do
          project = build(:conversion_project, significant_date: Date.new(2024, 1, 1), significant_date_provisional: false)

          expect(helper.confirmed_date_original_date(project)).to eq("Jan 2024 (Jan 2024)")
        end
      end
    end
  end

  describe "#project_type_as_string" do
    it "returns conversion or transfer" do
      conversion = build(:conversion_project)
      transfer = build(:transfer_project)

      expect(helper.project_type_as_string(conversion)).to eql "conversion"
      expect(helper.project_type_as_string(transfer)).to eql "transfer"
    end
  end

  describe "#projects_establishment_name_list" do
    it "returns all the project establishment names separated by a semi colon" do
      first_fake_project = double(Project, establishment: double(name: "Fake establishment one"))
      last_fake_project = double(Project, establishment: double(name: "Fake establishment two"))
      fake_project_group = double(FormAMultiAcademyTrust::ProjectGroup, projects: [first_fake_project, last_fake_project])

      expect(projects_establishment_name_list(fake_project_group)).to eql "Fake establishment one; Fake establishment two"
    end

    it "returns an empty string when there are no projects" do
      fake_project_group = double(FormAMultiAcademyTrust::ProjectGroup, projects: [])

      expect(projects_establishment_name_list(fake_project_group)).to eql ""
    end
  end
end
