require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#render_markdown" do
    let(:markdown) { "[link](https://some-path.com)" }

    before { allow(GovukMarkdown).to receive(:render).and_call_original }

    subject! { helper.render_markdown(markdown) }

    it "calls the GovukMarkdown renderer" do
      expect(GovukMarkdown).to have_received(:render).with(markdown)
    end

    it "sets html_safe" do
      expect(subject.html_safe?).to be true
    end

    it "does not strip out target attributes" do
      expect(subject).to eq "<p class=\"govuk-body-m\"><a href=\"https://some-path.com\" class=\"govuk-link\" target=\"_blank\">link</a></p>"
    end

    context "when the hint option is true" do
      let(:markdown) { "Content" }

      subject! { helper.render_markdown(markdown, hint: true) }

      it "replaces the 'govuk-body-m' class with 'govuk-hint'" do
        expect(subject).to eq "<p class=\"govuk-hint\">Content</p>"
      end
    end
  end

  describe "#safe_link_to" do
    let(:body) { "Link" }
    let(:url) { "https://example.com" }

    subject { safe_link_to(body, url) }

    context "when the url contains unsafe protocols" do
      let(:url) { "javascript:alert('malicious')" }

      it "removes unsafe protocols" do
        expect(subject).to_not include("javascript")
      end
    end

    it "adds the target blank attribute" do
      expect(subject).to include("target=\"_blank\"")
    end
  end

  describe "#support_email" do
    context "when the custom email subject is required (default)" do
      context "when the display name is nil" do
        subject { helper.support_email }

        it "returns a mailto link to the support email, with a custom subject and the email as the display name" do
          expect(subject).to eq "<a class=\"govuk-link\" href=\"mailto:regionalservices.rg@education.gov.uk?subject=Complete%20conversions%2C%20transfers%20and%20changes%3A%20support%20query\">regionalservices.rg@education.gov.uk</a>"
        end
      end

      context "when the display name is not nil" do
        let(:name) { "contact the complete conversions, transfers and changes team" }

        subject { helper.support_email(name) }

        it "returns a mailto link to the support email, with a custom subject and the supplied name" do
          expect(subject).to eq "<a class=\"govuk-link\" href=\"mailto:regionalservices.rg@education.gov.uk?subject=Complete%20conversions%2C%20transfers%20and%20changes%3A%20support%20query\">#{name}</a>"
        end
      end
    end

    context "when the custom email subject is not required" do
      context "when the display name is nil" do
        subject { helper.support_email(nil, false) }

        it "returns a mailto link to the support email with the email as the display name" do
          expect(subject).to eq "<a class=\"govuk-link\" href=\"mailto:regionalservices.rg@education.gov.uk\">regionalservices.rg@education.gov.uk</a>"
        end
      end

      context "when the display name is not nil" do
        let(:name) { "contact the complete conversions, transfers and changes team" }

        subject { helper.support_email(name, false) }

        it "returns a mailto link to the support email with the supplied name" do
          expect(subject).to eq "<a class=\"govuk-link\" href=\"mailto:regionalservices.rg@education.gov.uk\">#{name}</a>"
        end
      end
    end
  end

  describe "#enable_google_tag_manager?" do
    context "when not in production" do
      it "returns false" do
        ClimateControl.modify(
          USER_ENV: "development",
          GOOGLE_TAG_MANAGER_ID: ""
        ) do
          cookies[:ACCEPT_OPTIONAL_COOKIES] = true

          expect(enable_google_tag_manager?).to eq(false)
        end
      end
    end

    context "when there is no tag manager id" do
      it "returns false" do
        ClimateControl.modify(
          USER_ENV: "production",
          GOOGLE_TAG_MANAGER_ID: ""
        ) do
          cookies[:ACCEPT_OPTIONAL_COOKIES] = true

          expect(enable_google_tag_manager?).to eq(false)
        end
      end
    end

    context "when the user has rejected cookies" do
      it "returns false" do
        ClimateControl.modify(
          USER_ENV: "production",
          GOOGLE_TAG_MANAGER_ID: "THISISANID"
        ) do
          cookies[:ACCEPT_OPTIONAL_COOKIES] = false

          expect(enable_google_tag_manager?).to eq(false)
        end
      end
    end

    context "when the user has accepted cookies" do
      it "returns true" do
        ClimateControl.modify(
          USER_ENV: "production",
          GOOGLE_TAG_MANAGER_ID: "THISISANID"
        ) do
          cookies[:ACCEPT_OPTIONAL_COOKIES] = "true"

          expect(enable_google_tag_manager?).to eq(true)
        end
      end
    end
  end

  describe "#page_title" do
    it "returns the supplied title concatenated with the service name" do
      expect(helper.page_title("A page")).to eq("A page - #{t("service_name")}")
    end
  end

  describe "#export_from_date_range" do
    it "returns an array of options for the from date picker, all are on the first of the month" do
      current_date = Date.new(2024, 1, 1)
      first_date = Date.new(2022, 1, 1)
      last_date = Date.new(2026, 12, 1)

      travel_to current_date do
        options = helper.export_from_date_range

        expect(options.count).to be 60

        expect(options.first.id).to eql first_date
        expect(options.first.name).to eql "Jan 2022"
        expect(options.last.id).to eql last_date
        expect(options.last.name).to eql "Dec 2026"
      end
    end
  end

  describe "#export_to_date_range" do
    it "returns an array of options for the from date date picker, all are on the last of the month" do
      current_date = Date.new(2024, 1, 1)
      first_date = Date.new(2022, 1, 31)
      last_date = Date.new(2026, 12, 31)

      travel_to current_date do
        options = helper.export_to_date_range

        expect(options.count).to be 60

        expect(options.first.id).to eql first_date
        expect(options.first.name).to eql "Jan 2022"
        expect(options.last.id).to eql last_date
        expect(options.last.name).to eql "Dec 2026"
      end
    end
  end
end
