require "rails_helper"

RSpec.describe "check DB availability" do
  describe "db_available?" do
    context "when the DB is available" do
      it "returns true if there is a user" do
        create(:user)

        expect(Ops::DbAvailability.db_available?).to be true
      end
    end

    context "when the connection is cold and throws ActiveRecord::ConnectionNotEstablished" do
      before do
        create(:user)
        allow(ActiveRecord::Base).to receive(:connected?).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it "returns false " do
        expect(Ops::DbAvailability.db_available?).to be false
      end
    end

    context "when the DB is not available" do
      before do
        allow(ActiveRecord::Base).to receive(:connected?).and_return(false)
      end

      it "returns false if there is a user" do
        create(:user)

        expect(Ops::DbAvailability.db_available?).to be false
      end

      it "returns false if there is NO user and the db is NOT up" do
        expect(Ops::DbAvailability.db_available?).to be false
      end
    end
  end
end
