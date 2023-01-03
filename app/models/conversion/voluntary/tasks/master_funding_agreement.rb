class Conversion::Voluntary::Tasks::MasterFundingAgreement < TaskList::Task
  attribute :received
  attribute :cleared
  attribute :signed
  attribute :saved

  attribute :sent
  attribute :signed_secretary_state
end
