require "rails_helper"

RSpec.describe AcademiesApi::BaseApiModel do
  describe ".attribute_map" do
    context "when .attribute_map is not overridden" do
      let(:error_message) { ".attribute_map hasn't been overridden" }
      let(:testing_model) { Class.new(AcademiesApi::BaseApiModel) }

      it "raises a #{AcademiesApi::BaseApiModel::AttributeMapMissingError}" do
        expect { testing_model.attribute_map }.to raise_error(AcademiesApi::BaseApiModel::AttributeMapMissingError, error_message)
      end
    end
  end

  context "when the attribute map is defined correctly" do
    let(:establishment_name) { "Caludon castle school" }
    let(:response) { {establishmentName: establishment_name} }
    let(:json_response) { JSON.generate(response) }
    let(:testing_model) do
      Class.new(AcademiesApi::BaseApiModel) do
        attr_accessor :name

        def self.attribute_map
          {name: "establishmentName"}
        end
      end
    end

    subject { testing_model.new }

    describe "#from_json" do
      it "can map a JSON response to attributes" do
        expect(subject.from_json(json_response).name).to eq establishment_name
      end

      context "when there are attributes that are undefined on the model" do
        let(:response) { JSON.generate({establishmentName: establishment_name, otherProperty: "value"}) }

        before { allow(subject).to receive(:send) }

        it "only maps defined attributes" do
          expect(subject.from_json(response)).to have_received(:send).once
        end
      end
    end

    describe "#from_hash" do
      it "can map a hash to attributes" do
        expect(subject.from_hash(response).name).to eq establishment_name
      end
    end
  end
end
