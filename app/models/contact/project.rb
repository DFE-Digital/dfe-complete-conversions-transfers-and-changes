class Contact::Project < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project, class_name: "::Project"
  has_one :main_contact_for_project, class_name: "::Project", inverse_of: :main_contact
  has_one :main_contact_for_establishment, class_name: "::Project", inverse_of: :establishment_main_contact
  has_one :main_contact_for_incoming_trust, class_name: "::Project", inverse_of: :incoming_trust_main_contact
  has_one :main_contact_for_outgoing_trust, class_name: "::Project", inverse_of: :outgoing_trust_main_contact
  has_one :contact_for_chair_of_governors, class_name: "Conversion::Project", inverse_of: :chair_of_governors_contact

  def establishment_main_contact
    project.establishment_main_contact_id == id
  end

  def incoming_trust_main_contact
    project.incoming_trust_main_contact_id == id
  end

  def outgoing_trust_main_contact
    project.outgoing_trust_main_contact_id == id
  end
end
