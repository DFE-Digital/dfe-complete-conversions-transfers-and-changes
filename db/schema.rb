# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_09_135448) do
  create_table "contacts", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.string "name", null: false
    t.string "title", null: false
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0, null: false
    t.string "organisation_name"
    t.string "type"
    t.uuid "local_authority_id"
    t.index ["category"], name: "index_contacts_on_category"
    t.index ["project_id"], name: "index_contacts_on_project_id"
  end

  create_table "conversion_tasks_data", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.boolean "handover_review"
    t.boolean "handover_notes"
    t.boolean "handover_meeting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "stakeholder_kick_off_introductory_emails"
    t.boolean "stakeholder_kick_off_local_authority_proforma"
    t.boolean "stakeholder_kick_off_setup_meeting"
    t.boolean "stakeholder_kick_off_meeting"
    t.boolean "conversion_grant_check_vendor_account"
    t.boolean "conversion_grant_payment_form"
    t.boolean "conversion_grant_send_information"
    t.boolean "conversion_grant_share_payment_date"
    t.boolean "land_questionnaire_received"
    t.boolean "land_questionnaire_cleared"
    t.boolean "land_questionnaire_signed"
    t.boolean "land_questionnaire_saved"
    t.boolean "land_registry_received"
    t.boolean "land_registry_cleared"
    t.boolean "land_registry_saved"
    t.boolean "supplemental_funding_agreement_received"
    t.boolean "supplemental_funding_agreement_cleared"
    t.boolean "supplemental_funding_agreement_signed"
    t.boolean "supplemental_funding_agreement_saved"
    t.boolean "supplemental_funding_agreement_sent"
    t.boolean "supplemental_funding_agreement_signed_secretary_state"
    t.boolean "church_supplemental_agreement_received"
    t.boolean "church_supplemental_agreement_cleared"
    t.boolean "church_supplemental_agreement_signed"
    t.boolean "church_supplemental_agreement_signed_diocese"
    t.boolean "church_supplemental_agreement_saved"
    t.boolean "church_supplemental_agreement_sent"
    t.boolean "church_supplemental_agreement_signed_secretary_state"
    t.boolean "master_funding_agreement_received"
    t.boolean "master_funding_agreement_cleared"
    t.boolean "master_funding_agreement_signed"
    t.boolean "master_funding_agreement_saved"
    t.boolean "master_funding_agreement_sent"
    t.boolean "master_funding_agreement_signed_secretary_state"
    t.boolean "articles_of_association_received"
    t.boolean "articles_of_association_cleared"
    t.boolean "articles_of_association_signed"
    t.boolean "articles_of_association_saved"
    t.boolean "deed_of_variation_received"
    t.boolean "deed_of_variation_cleared"
    t.boolean "deed_of_variation_signed"
    t.boolean "deed_of_variation_saved"
    t.boolean "deed_of_variation_sent"
    t.boolean "deed_of_variation_signed_secretary_state"
    t.boolean "trust_modification_order_received"
    t.boolean "trust_modification_order_sent_legal"
    t.boolean "trust_modification_order_cleared"
    t.boolean "trust_modification_order_saved"
    t.boolean "direction_to_transfer_received"
    t.boolean "direction_to_transfer_cleared"
    t.boolean "direction_to_transfer_signed"
    t.boolean "direction_to_transfer_saved"
    t.boolean "single_worksheet_complete"
    t.boolean "single_worksheet_approve"
    t.boolean "single_worksheet_send"
    t.boolean "school_completed_emailed"
    t.boolean "school_completed_saved"
    t.boolean "redact_and_send_redact"
    t.boolean "redact_and_send_save_redaction"
    t.boolean "redact_and_send_send_redaction"
    t.boolean "update_esfa_update"
    t.boolean "receive_grant_payment_certificate_check_and_save"
    t.boolean "receive_grant_payment_certificate_update_kim"
    t.boolean "one_hundred_and_twenty_five_year_lease_email"
    t.boolean "one_hundred_and_twenty_five_year_lease_receive"
    t.boolean "one_hundred_and_twenty_five_year_lease_save_lease"
    t.boolean "subleases_received"
    t.boolean "subleases_cleared"
    t.boolean "subleases_signed"
    t.boolean "subleases_saved"
    t.boolean "subleases_email_signed"
    t.boolean "subleases_receive_signed"
    t.boolean "subleases_save_signed"
    t.boolean "tenancy_at_will_email_signed"
    t.boolean "tenancy_at_will_receive_signed"
    t.boolean "tenancy_at_will_save_signed"
    t.boolean "commercial_transfer_agreement_email_signed"
    t.boolean "commercial_transfer_agreement_receive_signed"
    t.boolean "commercial_transfer_agreement_save_signed"
    t.boolean "share_information_email"
    t.boolean "redact_and_send_send_solicitors"
    t.boolean "articles_of_association_not_applicable"
    t.boolean "church_supplemental_agreement_not_applicable"
    t.boolean "deed_of_variation_not_applicable"
    t.boolean "direction_to_transfer_not_applicable"
    t.boolean "master_funding_agreement_not_applicable"
    t.boolean "one_hundred_and_twenty_five_year_lease_not_applicable"
    t.boolean "subleases_not_applicable"
    t.boolean "tenancy_at_will_not_applicable"
    t.boolean "trust_modification_order_not_applicable"
    t.boolean "stakeholder_kick_off_check_provisional_conversion_date"
    t.boolean "conversion_grant_not_applicable"
    t.boolean "sponsored_support_grant_eligibility"
    t.boolean "sponsored_support_grant_payment_amount"
    t.boolean "sponsored_support_grant_payment_form"
    t.boolean "sponsored_support_grant_send_information"
    t.boolean "sponsored_support_grant_inform_trust"
    t.boolean "sponsored_support_grant_not_applicable"
    t.boolean "handover_not_applicable"
    t.string "academy_details_name"
    t.string "risk_protection_arrangement_option"
    t.boolean "check_accuracy_of_higher_needs_confirm_number"
    t.boolean "check_accuracy_of_higher_needs_confirm_published_number"
    t.boolean "complete_notification_of_change_not_applicable"
    t.boolean "complete_notification_of_change_tell_local_authority"
    t.boolean "complete_notification_of_change_check_document"
    t.boolean "complete_notification_of_change_send_document"
    t.string "sponsored_support_grant_type"
  end

  create_table "local_authorities", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "address_1", null: false
    t.string "address_2"
    t.string "address_3"
    t.string "address_town"
    t.string "address_county"
    t.string "address_postcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "project_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "task_identifier"
    t.uuid "significant_date_history_id"
    t.index ["project_id"], name: "index_notes_on_project_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "projects", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.integer "urn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "team_leader_id"
    t.integer "incoming_trust_ukprn", null: false
    t.uuid "regional_delivery_officer_id"
    t.uuid "caseworker_id"
    t.datetime "assigned_at"
    t.date "advisory_board_date"
    t.text "advisory_board_conditions"
    t.text "establishment_sharepoint_link"
    t.datetime "completed_at"
    t.text "incoming_trust_sharepoint_link"
    t.string "type"
    t.uuid "assigned_to_id"
    t.date "significant_date"
    t.boolean "significant_date_provisional", default: true
    t.boolean "directive_academy_order", default: false
    t.string "region"
    t.integer "academy_urn"
    t.uuid "tasks_data_id"
    t.string "tasks_data_type"
    t.uuid "funding_agreement_contact_id"
    t.integer "outgoing_trust_ukprn"
    t.string "team"
    t.boolean "two_requires_improvement", default: false
    t.text "outgoing_trust_sharepoint_link"
    t.boolean "all_conditions_met", default: false
    t.index ["assigned_to_id"], name: "index_projects_on_assigned_to_id"
    t.index ["caseworker_id"], name: "index_projects_on_caseworker_id"
    t.index ["regional_delivery_officer_id"], name: "index_projects_on_regional_delivery_officer_id"
    t.index ["team_leader_id"], name: "index_projects_on_team_leader_id"
    t.index ["urn"], name: "index_projects_on_urn"
  end

  create_table "significant_date_histories", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.date "revised_date"
    t.date "previous_date"
    t.uuid "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfer_tasks_data", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "handover_review"
    t.boolean "handover_notes"
    t.boolean "handover_meeting"
    t.boolean "handover_not_applicable"
    t.boolean "stakeholder_kick_off_introductory_emails"
    t.boolean "stakeholder_kick_off_setup_meeting"
    t.boolean "stakeholder_kick_off_meeting"
    t.boolean "master_funding_agreement_received"
    t.boolean "master_funding_agreement_cleared"
    t.boolean "master_funding_agreement_signed"
    t.boolean "master_funding_agreement_saved"
    t.boolean "master_funding_agreement_signed_secretary_state"
    t.boolean "master_funding_agreement_not_applicable"
    t.boolean "deed_of_novation_and_variation_received"
    t.boolean "deed_of_novation_and_variation_cleared"
    t.boolean "deed_of_novation_and_variation_signed_outgoing_trust"
    t.boolean "deed_of_novation_and_variation_signed_incoming_trust"
    t.boolean "deed_of_novation_and_variation_saved"
    t.boolean "deed_of_novation_and_variation_signed_secretary_state"
    t.boolean "deed_of_novation_and_variation_sent"
    t.boolean "articles_of_association_received"
    t.boolean "articles_of_association_cleared"
    t.boolean "articles_of_association_signed"
    t.boolean "articles_of_association_saved"
    t.boolean "articles_of_association_not_applicable"
    t.boolean "commercial_transfer_agreement_confirm_agreed"
    t.boolean "commercial_transfer_agreement_confirm_signed"
    t.boolean "commercial_transfer_agreement_save_confirmation_emails"
  end

  create_table "users", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manage_team", default: false
    t.boolean "add_new_project", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "active_directory_user_id"
    t.boolean "assign_to_project", default: false
    t.boolean "manage_user_accounts", default: false
    t.string "active_directory_user_group_ids"
    t.string "team"
    t.datetime "deactivated_at"
    t.boolean "manage_conversion_urns", default: false
    t.boolean "manage_local_authorities", default: false
    t.datetime "latest_session"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "contacts", "projects"
  add_foreign_key "notes", "projects"
  add_foreign_key "notes", "users"
  add_foreign_key "projects", "users", column: "assigned_to_id"
  add_foreign_key "projects", "users", column: "caseworker_id"
  add_foreign_key "projects", "users", column: "regional_delivery_officer_id"
  add_foreign_key "projects", "users", column: "team_leader_id"
end
