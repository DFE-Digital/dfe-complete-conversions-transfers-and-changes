class Conversion::Task::FundingAgreementContactTaskForm < ::BaseTaskForm
  attribute :contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user

    super(@tasks_data, @user)
  end

  def save
    change_class_for_funding_letters_contact(contact_id)
    @tasks_data.update(funding_agreement_contact_contact_id: contact_id)
  end

  private def change_class_for_funding_letters_contact(contact_id)
    external_contacts = @tasks_data.project.external_contacts
    external_contacts.each do |contact|
      if contact.id == contact_id
        contact.update(type: "Contact::FundingAgreementLetters")
      else
        contact.update(type: "Contact::Project")
      end
    end
  end
end
