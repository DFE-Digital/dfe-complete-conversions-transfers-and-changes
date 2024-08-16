class KeyContacts < ApplicationRecord
  belongs_to :project
  belongs_to :headteacher, class_name: "Contact", optional: true
  belongs_to :chair_of_governors, class_name: "Contact", optional: true
  belongs_to :incoming_trust_ceo, class_name: "Contact", optional: true
end
