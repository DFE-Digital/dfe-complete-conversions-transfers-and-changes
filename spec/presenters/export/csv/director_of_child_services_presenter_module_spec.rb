require "rails_helper"

RSpec.describe Export::Csv::DirectorOfChildServicesPresenterModule do
  let(:project) { build(:conversion_project) }
  subject { DirectorOfChildServicesPresenterModuleTestClass.new(project) }

  before do
    allow(project).to receive(:director_of_child_services).and_return(known_director_of_child_services)
  end

  it "presents the name" do
    expect(subject.director_of_child_services_name).to eql "First Last"
  end

  it "presents the role" do
    expect(subject.director_of_child_services_role).to eql "Director of child services"
  end

  it "presents the email" do
    expect(subject.director_of_child_services_email).to eql "first.last@localauthority.com"
  end

  def known_director_of_child_services
    double(
      Contact::DirectorOfChildServices,
      name: "First Last",
      title: "Director of child services",
      email: "first.last@localauthority.com"
    )
  end
end

class DirectorOfChildServicesPresenterModuleTestClass
  include Export::Csv::DirectorOfChildServicesPresenterModule

  def initialize(project)
    @project = project
    @director_of_child_services = @project.director_of_child_services
  end
end
