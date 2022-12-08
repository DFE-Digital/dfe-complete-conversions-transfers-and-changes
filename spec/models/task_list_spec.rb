require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskList, type: :model do
  let(:instance) { described_class.new }

  describe "mapping" do
    context '#land_questionnaire' do
      let(:form_model) { build :land_questionnaire }

      before do
        instance.land_questionnaire = form_model
      end

      {
        land_questionnaire_received: :received,
        land_questionnaire_cleared: :cleared,
        land_questionnaire_signed_by_solicitor: :signed_by_solicitor,
        land_questionnaire_saved_in_school_sharepoint: :saved_in_school_sharepoint
      }.each_pair do |column, model_attribute|
        it "is expected to map #{column} to #{model_attribute}" do
          expect(instance.send(column)).to eq form_model.send(model_attribute)
        end
      end

      it 'returns the form_model' do
        expect(instance.land_questionnaire).to eq form_model
      end
    end
  end
end
