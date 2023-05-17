class MakeContactsSingleTableInheritance < ActiveRecord::Migration[7.0]
  def up
    add_column :contacts, :type, :string

    Contact::Project.all.each do |contact|
      if contact.project
        contact.type = "Contact::Project"
        contact.save(validate: false)
      end
    end
  end

  def down
    remove_column :contacts, :type, :string
  end
end
