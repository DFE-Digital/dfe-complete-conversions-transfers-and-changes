class KeyContacts < ApplicationRecord
  belongs_to :project
  belongs_to :headteacher, class_name: "Contact", optional: true
end
