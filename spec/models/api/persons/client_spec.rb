require "rails_helper"

RSpec.describe Api::Persons::Client do
  after do
    # Clear the cache after each spec because we use the same Redis store in development and test
    Rails.cache.clear
  end

  context "when there is a auth token" do
    before do
      allow(Rails.cache).to receive(:read).with(Api::Persons::Client::TOKEN_CACHE_KEY).and_return("afaketoken")
    end

    describe "#member_for_constituency" do
      context "when passed a known and valid constituency name" do
        subject {
          described_class.new(
            api_connection: test_api_successful_connection,
            auth_connection: test_auth_successful_connection
          )
        }

        it "returns a result with the member details inside" do
          result = subject.member_for_constituency("test")

          expect(result.object).to be_a Api::Persons::MemberDetails
          expect(result.error).to be_nil

          member = result.object

          expect(member.name).to eql "First Last"
          expect(member.email).to eql "lastf@parliament.gov.uk"
        end
      end

      context "when passed an unknown yet valid constituency name" do
        subject {
          described_class.new(
            api_connection: test_api_not_found_connection,
            auth_connection: test_auth_successful_connection
          )
        }

        it "returns a result with the error inside" do
          result = subject.member_for_constituency("test")

          expect(result.object).to be_nil
          expect(result.error).to be_a Api::Persons::Client::NotFoundError
        end
      end

      context "when an error occurs" do
        subject {
          described_class.new(
            api_connection: test_api_error_connection,
            auth_connection: test_auth_successful_connection
          )
        }

        it "returns a result with the error inside" do
          result = subject.member_for_constituency("test")

          expect(result.object).to be_nil
          expect(result.error).to be_a Api::Persons::Client::Error
        end
      end
    end
  end

  context "when there is no auth token" do
    before do
      allow(Rails.cache).to receive(:read).with(Api::Persons::Client::TOKEN_CACHE_KEY).and_return(nil)
    end

    context "when the token request is successful" do
      subject {
        described_class.new(
          api_connection: test_api_successful_connection,
          auth_connection: test_auth_successful_connection
        )
      }

      it "gets a new token and calls the api" do
        allow(Rails.cache).to receive(:write).and_call_original

        member = subject.member_for_constituency("test").object

        expect(Rails.cache).to have_received(:write).once

        expect(member.name).to eql "First Last"
        expect(member.email).to eql "lastf@parliament.gov.uk"
      end
    end

    context "when the token request fails" do
      subject {
        described_class.new(
          api_connection: nil,
          auth_connection: test_auth_error_connection
        )
      }

      it "raises the appropriate error" do
        expect { subject.member_for_constituency("test") }.to raise_error Api::Persons::Client::AuthError
      end
    end
  end
end
