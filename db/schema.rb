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

ActiveRecord::Schema[7.0].define(version: 2023_01_05_165414) do
  create_table "actions", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.boolean "completed", default: false, null: false
    t.uuid "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hint"
    t.string "guidance_summary"
    t.text "guidance_text"
    t.string "action_type"
    t.string "padding", default: "normal"
    t.index ["task_id"], name: "index_actions_on_task_id"
  end

  create_table "contacts", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.string "name", null: false
    t.string "title", null: false
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0, null: false
    t.index ["category"], name: "index_contacts_on_category"
    t.index ["project_id"], name: "index_contacts_on_project_id"
  end

  create_table "conversion_details", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "type"
    t.uuid "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversion_involuntary_task_lists", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.boolean "handover_review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "subleases_not_applicable"
    t.boolean "subleases_received"
    t.boolean "subleases_cleared"
    t.boolean "subleases_signed"
    t.boolean "subleases_saved"
    t.boolean "subleases_email_signed"
    t.boolean "subleases_receive_signed"
    t.boolean "subleases_save_signed"
    t.boolean "handover_notes"
    t.boolean "handover_meeting"
    t.boolean "stakeholder_kick_off_introductory_emails"
    t.boolean "stakeholder_kick_off_local_authority_proforma"
    t.boolean "stakeholder_kick_off_confirm_target_conversion_date"
    t.boolean "stakeholder_kick_off_setup_meeting"
    t.boolean "conversion_grant_eligibility"
    t.boolean "conversion_grant_payment_amount"
    t.boolean "conversion_grant_payment_form"
    t.boolean "conversion_grant_send_information"
    t.boolean "conversion_grant_inform_trust"
    t.boolean "land_questionnaire_received"
    t.boolean "land_questionnaire_cleared"
    t.boolean "land_questionnaire_signed"
    t.boolean "land_questionnaire_saved"
    t.boolean "land_registry_received"
    t.boolean "land_registry_cleared"
    t.boolean "land_registry_saved"
    t.boolean "supplemental_funding_agreeement_received"
    t.boolean "supplemental_funding_agreeement_cleared"
    t.boolean "supplemental_funding_agreeement_signed"
    t.boolean "supplemental_funding_agreeement_saved"
    t.boolean "supplemental_funding_agreeement_sent"
    t.boolean "supplemental_funding_agreeement_signed_secretary_state"
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
    t.boolean "trust_modification_order_received"
    t.boolean "trust_modification_order_sent_legal"
    t.boolean "trust_modification_order_cleared"
    t.boolean "trust_modification_order_saved"
    t.boolean "direction_to_transfer_received"
    t.boolean "direction_to_transfer_cleared"
    t.boolean "direction_to_transfer_signed"
    t.boolean "direction_to_transfer_saved"
    t.boolean "one_hundred_and_twenty_five_year_lease_not_applicable"
    t.boolean "one_hundred_and_twenty_five_year_lease_email"
    t.boolean "one_hundred_and_twenty_five_year_lease_receive"
    t.boolean "one_hundred_and_twenty_five_year_lease_save"
    t.boolean "tenancy_at_will_email_signed"
    t.boolean "tenancy_at_will_receive_signed"
    t.boolean "tenancy_at_will_save_signed"
    t.boolean "tenancy_at_will_not_applicable"
    t.boolean "commercial_transfer_agreement_email_signed"
    t.boolean "commercial_transfer_agreement_receive_signed"
    t.boolean "commercial_transfer_agreement_save_signed"
    t.boolean "church_supplemental_agreement_not_applicable"
    t.boolean "master_funding_agreement_not_applicable"
    t.boolean "articles_of_association_not_applicable"
    t.boolean "deed_of_variation_not_applicable"
    t.boolean "trust_modification_order_not_applicable"
    t.boolean "direction_to_tansfer_not_applicable"
    t.boolean "handover_not_applicable"
    t.boolean "check_baseline_confirm"
    t.boolean "single_worksheet_complete"
    t.boolean "single_worksheet_approve"
    t.boolean "single_worksheet_send"
    t.boolean "school_completed_emailed"
    t.boolean "school_completed_saved"
    t.boolean "conditions_met_emailed"
    t.boolean "share_information_email"
    t.boolean "tell_regional_delivery_officer_email"
    t.boolean "redact_and_send_redact"
    t.boolean "redact_and_send_save"
    t.boolean "redact_and_send_send"
    t.boolean "redact_and_send_send_solicitors"
    t.boolean "update_esfa_update"
  end

  create_table "conversion_voluntary_task_lists", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.boolean "handover_review"
    t.boolean "handover_notes"
    t.boolean "handover_meeting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "stakeholder_kick_off_introductory_emails"
    t.boolean "stakeholder_kick_off_local_authority_proforma"
    t.boolean "stakeholder_kick_off_confirm_target_conversion_date"
    t.boolean "stakeholder_kick_off_setup_meeting"
    t.boolean "stakeholder_kick_off_meeting"
    t.boolean "stakeholder_kick_off_conversion_checklist"
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
    t.boolean "check_baseline_confirm"
    t.boolean "single_worksheet_complete"
    t.boolean "single_worksheet_approve"
    t.boolean "single_worksheet_send"
    t.boolean "school_completed_emailed"
    t.boolean "school_completed_saved"
    t.boolean "conditions_met_emailed"
    t.boolean "redact_and_send_redact"
    t.boolean "redact_and_send_save"
    t.boolean "redact_and_send_send"
    t.boolean "update_esfa_update"
    t.boolean "receive_grant_payment_certificate_check_and_save"
    t.boolean "receive_grant_payment_certificate_update_kim"
    t.boolean "receive_grant_payment_certificate_update_sheet"
    t.boolean "one_hundred_and_twenty_five_year_lease_email"
    t.boolean "one_hundred_and_twenty_five_year_lease_receive"
    t.boolean "one_hundred_and_twenty_five_year_lease_save"
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
    t.boolean "tell_regional_delivery_officer_email"
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
  end

  create_table "notes", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "project_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "task_id"
    t.string "task_identifier"
    t.index ["project_id"], name: "index_notes_on_project_id"
    t.index ["task_id"], name: "index_notes_on_task_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "projects", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.integer "urn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "team_leader_id"
    t.integer "incoming_trust_ukprn", null: false
    t.date "provisional_conversion_date", null: false
    t.uuid "regional_delivery_officer_id"
    t.uuid "caseworker_id"
    t.datetime "caseworker_assigned_at"
    t.date "advisory_board_date"
    t.text "advisory_board_conditions"
    t.text "establishment_sharepoint_link"
    t.datetime "completed_at"
    t.text "trust_sharepoint_link"
    t.string "type"
    t.uuid "task_list_id"
    t.string "task_list_type"
    t.index ["caseworker_id"], name: "index_projects_on_caseworker_id"
    t.index ["regional_delivery_officer_id"], name: "index_projects_on_regional_delivery_officer_id"
    t.index ["team_leader_id"], name: "index_projects_on_team_leader_id"
    t.index ["urn"], name: "index_projects_on_urn"
  end

  create_table "sections", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.uuid "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_sections_on_project_id"
  end

  create_table "tasks", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.boolean "completed", default: false, null: false
    t.uuid "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hint"
    t.string "guidance_summary"
    t.text "guidance_text"
    t.boolean "optional"
    t.boolean "not_applicable", default: false
    t.string "slug"
    t.index ["section_id"], name: "index_tasks_on_section_id"
  end

  create_table "users", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "team_leader", default: false
    t.boolean "regional_delivery_officer", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "active_directory_user_id"
    t.boolean "caseworker", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "actions", "tasks"
  add_foreign_key "contacts", "projects"
  add_foreign_key "notes", "projects"
  add_foreign_key "notes", "tasks"
  add_foreign_key "notes", "users"
  add_foreign_key "projects", "users", column: "caseworker_id"
  add_foreign_key "projects", "users", column: "regional_delivery_officer_id"
  add_foreign_key "projects", "users", column: "team_leader_id"
  add_foreign_key "sections", "projects"
  add_foreign_key "tasks", "sections"
end
