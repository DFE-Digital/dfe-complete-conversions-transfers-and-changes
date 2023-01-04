class Conversion::Voluntary::Tasks::DirectionToTransfer < TaskList::Task
  attribute :received
  attribute :cleared
  attribute :signed
  attribute :saved

  attribute :sent
  attribute :signed_secretary_state
end
