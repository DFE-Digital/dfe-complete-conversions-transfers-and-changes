require "rails_helper"

RSpec.describe Capability do
  describe "enforces presence of #name and #description" do
    let(:capability) do
      Capability.new(name: nil, description: nil).tap do |capability|
        capability.valid?
      end
    end

    it "is invalid without #name" do
      expect(capability.errors.full_messages).to include("Name can't be blank")
    end

    it "is invalid without #description" do
      expect(capability.errors.full_messages).to include("Description can't be blank")
    end
  end

  describe "enforces uniqueness of #name" do
    context "when a capability with the same name already exists" do
      before do
        Capability.create(
          name: :can_do_it,
          description: "Can do it"
        )
      end

      it("will not be valid") do
        new_capability = Capability.new(
          name: :can_do_it,
          description: "Also can do it"
        )

        expect(new_capability.valid?).to be false
      end
    end
  end

  describe "capability finders" do
    describe "::manage_team" do
      context "when the team exists" do
        let!(:existing_capability) do
          Capability.create(
            name: :manage_team,
            description: "Capabilities dependent on the User#manage_team attribute"
          )
        end

        it "returns the existing capability" do
          expect(Capability.manage_team).to eq(existing_capability)
        end
      end

      context "when the capability does not exist" do
        it "creates the capability" do
          allow(Capability).to receive(:find_or_create_by)

          Capability.manage_team

          expect(Capability).to have_received(:find_or_create_by)
            .with(
              name: :manage_team,
              description: "Capabilities dependent on the User#manage_team attribute"
            )
        end

        it "returns that newly created capability" do
          newly_created_capability = Capability.manage_team

          expect(newly_created_capability).to be_persisted
          expect(newly_created_capability.name).to eq("manage_team")
          expect(newly_created_capability.description).to match(/User#manage_team attribute/)
        end
      end
    end

    describe "::add_new_project" do
      context "when the team exists" do
        let!(:existing_capability) do
          Capability.create(
            name: :add_new_project,
            description: "Capabilities dependent on the User#add_new_project attribute"
          )
        end

        it "returns the existing capability" do
          expect(Capability.add_new_project).to eq(existing_capability)
        end
      end

      context "when the capability does not exist" do
        it "creates the capability" do
          allow(Capability).to receive(:find_or_create_by)

          Capability.add_new_project

          expect(Capability).to have_received(:find_or_create_by)
            .with(
              name: :add_new_project,
              description: "Capabilities dependent on the User#add_new_project attribute"
            )
        end

        it "returns that newly created capability" do
          newly_created_capability = Capability.add_new_project

          expect(newly_created_capability).to be_persisted
          expect(newly_created_capability.name).to eq("add_new_project")
          expect(newly_created_capability.description).to match(/User#add_new_project attribute/)
        end
      end
    end

    describe "::assign_to_project" do
      context "when the team exists" do
        let!(:existing_capability) do
          Capability.create(
            name: :assign_to_project,
            description: "Capabilities dependent on the User#assign_to_project attribute"
          )
        end

        it "returns the existing capability" do
          expect(Capability.assign_to_project).to eq(existing_capability)
        end
      end

      context "when the capability does not exist" do
        it "creates the capability" do
          allow(Capability).to receive(:find_or_create_by)

          Capability.assign_to_project

          expect(Capability).to have_received(:find_or_create_by)
            .with(
              name: :assign_to_project,
              description: "Capabilities dependent on the User#assign_to_project attribute"
            )
        end

        it "returns that newly created capability" do
          newly_created_capability = Capability.assign_to_project

          expect(newly_created_capability).to be_persisted
          expect(newly_created_capability.name).to eq("assign_to_project")
          expect(newly_created_capability.description).to match(/User#assign_to_project attribute/)
        end
      end
    end
  end
end
