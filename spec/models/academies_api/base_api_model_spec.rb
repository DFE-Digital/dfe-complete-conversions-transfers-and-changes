require "rails_helper"

RSpec.describe AcademiesApi::BaseApiModel do
  shared_examples "a method which maps a response to model attributes" do
    let(:establishment_name) { "Caludon castle school" }
    let(:establishment_type) { "Academy converter" }
    let(:response) do
      {
        establishmentName: establishment_name,
        establishmentType: {
          name: establishment_type
        }
      }
    end
    let(:json_response) { JSON.generate(response) }
    let(:testing_model) do
      Class.new(AcademiesApi::BaseApiModel) do
        attr_accessor :name, :type

        def self.attribute_map
          {
            name: "establishmentName",
            type: "establishmentType.name"
          }
        end
      end
    end
    let(:testing_model_instance) { testing_model.new }

    it "can map response to attributes" do
      expect(subject.name).to eq establishment_name
      expect(subject.type).to eq establishment_type
    end

    context "when there are attributes that are undefined on the model" do
      let(:response) { {establishmentName: establishment_name, otherProperty: "value"} }
      let(:json_response) { JSON.generate(response) }

      before { allow(testing_model_instance).to receive(:send) }

      it "only maps defined attributes" do
        expect(subject).to have_received(:send)
      end
    end
  end

  describe ".attribute_map" do
    context "when .attribute_map is not overridden" do
      let(:error_message) { ".attribute_map hasn't been overridden" }
      let(:testing_model) { Class.new(AcademiesApi::BaseApiModel) }

      it "raises a #{AcademiesApi::BaseApiModel::AttributeMapMissingError}" do
        expect { testing_model.attribute_map }.to raise_error(AcademiesApi::BaseApiModel::AttributeMapMissingError, error_message)
      end
    end
  end

  describe "#from_json" do
    it_behaves_like "a method which maps a response to model attributes"

    subject { testing_model_instance.from_json(json_response) }
  end

  describe "#from_hash" do
    it_behaves_like "a method which maps a response to model attributes"

    subject { testing_model_instance.from_hash(response) }
  end
end
