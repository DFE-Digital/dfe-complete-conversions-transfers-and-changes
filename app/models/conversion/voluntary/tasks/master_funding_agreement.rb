class Conversion::Voluntary::Tasks::MasterFundingAgreement < TaskList::OptionalTask
  attribute :received
  attribute :cleared
  attribute :signed
  attribute :saved

  attribute :sent
  attribute :signed_secretary_state
end
