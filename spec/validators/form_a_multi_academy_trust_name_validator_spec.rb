require "rails_helper"

class FormAMultiAcademyTrustNameValidatorTest
  include ActiveModel::Validations
  attr_accessor :new_trust_reference_number
  attr_accessor :new_trust_name

  validates_with FormAMultiAcademyTrustNameValidator
end

RSpec.describe FormAMultiAcademyTrustNameValidator do
  subject { FormAMultiAcademyTrustNameValidatorTest.new }

  before do
    mock_successful_api_response_to_create_any_project
    create(:conversion_project, new_trust_reference_number: "TR12345", new_trust_name: "Big new trust")
    create(:conversion_project, new_trust_reference_number: "TR12345", new_trust_name: "Big new trust")
  end

  it "is valid if there is no new trust reference number" do
    subject.new_trust_reference_number = ""
    subject.new_trust_name = "New trust name"

    expect(subject).to be_valid
  end

  it "is valid if there is no new trust name" do
    subject.new_trust_reference_number = "TR1234567"
    subject.new_trust_name = ""

    expect(subject).to be_valid
  end

  it "is valid if the new trust name matches the existing name" do
    subject.new_trust_reference_number = "TR12345"
    subject.new_trust_name = "Big new trust"

    expect(subject).to be_valid
  end

  it "is valid if there are no other projects with the same reference number" do
    subject.new_trust_reference_number = "TR00000"
    subject.new_trust_name = "Big new trust"

    expect(subject).to be_valid
  end

  it "adds an error if the new trust name is different to the name in the existing project" do
    subject.new_trust_reference_number = "TR12345"
    subject.new_trust_name = "New trust name"

    expect(subject).to be_invalid
    expect(subject.errors.messages[:new_trust_name].first).to include "Big new trust"
  end
end
