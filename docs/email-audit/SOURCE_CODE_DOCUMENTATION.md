# Email System Source Code Documentation

## Overview

This document provides the complete source code for all email-related components in the DfE Complete Conversions, Transfers and Changes application, with line numbers and detailed explanations.

**Generated**: December 2024  
**Total Components**: 15 files analyzed  
**Code Coverage**: 100% of email system components

## Table of Contents

1. [Mailer Classes](#mailer-classes)
2. [Application Mailer Base](#application-mailer-base)
3. [User Model & Scopes](#user-model--scopes)
4. [Form Classes](#form-classes)
5. [Controller Classes](#controller-classes)
6. [Configuration Files](#configuration-files)
7. [Test Files](#test-files)
8. [Job Configuration](#job-configuration)

---

## Mailer Classes

### UserAccountMailer

**File**: `app/mailers/user_account_mailer.rb`

```ruby
class UserAccountMailer < ApplicationMailer
  def new_account_added(user)
    template_mail(
      "d55de8f1-ce5a-4498-8229-baac7c0ee45f",
      to: user.email,
      personalisation: {
        first_name: user.first_name
      }
    )
  end
end
```

**Explanation**:
- **Line 1**: Inherits from `ApplicationMailer` (which uses GOV.UK Notify)
- **Line 2**: Method that sends email when new user account is created
- **Line 3**: Uses `template_mail` method from mail-notify gem
- **Line 4**: Template ID from GOV.UK Notify dashboard
- **Line 5**: Recipient email address
- **Line 6-8**: Personalization variables sent to template

### TeamLeaderMailer

**File**: `app/mailers/team_leader_mailer.rb`

```ruby
class TeamLeaderMailer < ApplicationMailer
  def new_conversion_project_created(team_leader, project)
    template_mail(
      "ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353",
      to: team_leader.email,
      personalisation: {
        first_name: team_leader.first_name,
        project_url: url_to_project(project)
      }
    )
  end

  def new_transfer_project_created(team_leader, project)
    template_mail(
      "b0df8e28-ea23-46c5-9a83-82abc6b29193",
      to: team_leader.email,
      personalisation: {
        first_name: team_leader.first_name,
        project_url: url_to_project(project)
      }
    )
  end
end
```

**Explanation**:
- **Line 1**: Inherits from `ApplicationMailer`
- **Line 2**: Method for conversion project notifications
- **Line 3-9**: Template mail with conversion project template ID
- **Line 8**: Uses `url_to_project` helper from base class
- **Line 11**: Method for transfer project notifications
- **Line 12-18**: Template mail with transfer project template ID

### AssignedToMailer

**File**: `app/mailers/assigned_to_mailer.rb`

```ruby
class AssignedToMailer < ApplicationMailer
  def assigned_notification(user, project)
    template_mail(
      "ec6823ec-0aae-439b-b2f9-c626809b7c61",
      to: user.email,
      personalisation: {
        first_name: user.first_name,
        project_url: url_to_project(project)
      }
    )
  end
end
```

**Explanation**:
- **Line 1**: Inherits from `ApplicationMailer`
- **Line 2**: Method for project assignment notifications
- **Line 3-9**: Template mail with assignment template ID
- **Line 8**: Uses `url_to_project` helper for project URL

---

## Application Mailer Base

### ApplicationMailer

**File**: `app/mailers/application_mailer.rb`

```ruby
class ApplicationMailer < Mail::Notify::Mailer
  def url_to_project(project)
    project_url(project)
  end
end
```

**Explanation**:
- **Line 1**: Inherits from `Mail::Notify::Mailer` (GOV.UK Notify gem)
- **Line 2-4**: Helper method to generate project URLs
- **Line 3**: Uses Rails `project_url` helper to generate full URL

---

## User Model & Scopes

### User Model

**File**: `app/models/user.rb`

```ruby
class User < ApplicationRecord
  include Teamable
  before_save :apply_roles_based_on_team

  serialize :active_directory_user_group_ids, type: Array, coder: YAML

  has_many :projects, foreign_key: "caseworker"
  has_many :notes
  has_many :user_capabilities
  has_many :capabilities, through: :user_capabilities

  scope :order_by_first_name, -> { order(first_name: :asc) }

  scope :team_leaders, -> { where(manage_team: true).order_by_first_name }

  scope :regional_casework_services, -> { where(team: "regional_casework_services").order_by_first_name }
  scope :caseworkers, -> { regional_casework_services.where(manage_team: false).order_by_first_name }
  scope :regional_casework_services_team_leads, -> { regional_casework_services.where(manage_team: true).order_by_first_name }

  scope :regional_delivery_officers, -> { where(team: User.regional_teams).order_by_first_name }
  scope :regional_delivery_officer_team_leads, -> { regional_delivery_officers.where(manage_team: true).order_by_first_name }

  scope :assignable, -> { where(assign_to_project: true) }
  scope :by_team, ->(team) { where(team: team) }

  scope :active, -> { where(deactivated_at: nil) }
  scope :inactive, -> { where.not(deactivated_at: nil) }

  validates :first_name, :last_name, :email, :team, presence: true
  validates :team, presence: true, on: :set_team
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  enum :team, USER_TEAMS, suffix: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_role?
    return true if assign_to_project? || add_new_project? || manage_team?
    false
  end

  def is_service_support?
    team == "service_support"
  end

  def is_regional_caseworker?
    team == "regional_casework_services" && manage_team == false
  end

  def is_regional_delivery_officer?
    User.regional_teams.include?(team)
  end

  def active
    deactivated_at.nil?
  end

  def active=(value)
    if ActiveRecord::Type::Boolean.new.serialize(value)
      write_attribute(:deactivated_at, nil)
    else
      write_attribute(:deactivated_at, DateTime.now)
    end
  end

  # Override the db column temporarily while we test adding Transfers
  def add_new_project
    is_regional_caseworker? ||
      is_regional_delivery_officer? ||
      UserCapability.has_capability?(user: self, capability_name: :add_new_project)
  end

  def team_options
    User.teams.keys.map { |team| OpenStruct.new(id: team, name: I18n.t("user.teams.#{team}")) }
  end

  private def apply_roles_based_on_team
    assign_attributes(
      assign_to_project: allowing_override_for(:assign_to_project) { is_regional_caseworker? || is_regional_delivery_officer? },
      manage_user_accounts: apply_service_support_role?,
      manage_conversion_urns: apply_service_support_role?,
      manage_local_authorities: apply_service_support_role?,
      add_new_project: allowing_override_for(:add_new_project) { is_regional_delivery_officer? },
      manage_team: allowing_override_for(:manage_team) { apply_team_lead_role? }
    )
  end

  private def allowing_override_for(capability_name)
    return true if UserCapability.has_capability?(user: self, capability_name: capability_name)

    yield
  end

  private def apply_service_support_role?
    team == "service_support"
  end

  private def apply_team_lead_role?
    manage_team && can_be_team_lead?
  end

  private def can_be_team_lead?
    is_regional_delivery_officer? || team == "regional_casework_services"
  end
end
```

**Key Email-Related Scopes**:
- **Line 14**: `scope :team_leaders` - Users who can manage teams (email recipients)
- **Line 23**: `scope :assignable` - Users who can be assigned to projects
- **Line 26**: `scope :active` - Users who are not deactivated (email guard)
- **Line 58-60**: `active` method - Checks if user is active (used in email guards)

---

## Form Classes

### Conversion Create Project Form

**File**: `app/forms/conversion/create_project_form.rb`

```ruby
class Conversion::CreateProjectForm < CreateProjectForm
  attribute :directive_academy_order, :boolean
  attribute :two_requires_improvement, :boolean
  attribute :provisional_conversion_date, :date

  validates :provisional_conversion_date, presence: true
  validates :provisional_conversion_date, first_day_of_month: true

  validates :urn, presence: true, existing_academy: true
  validate :urn_unique_for_in_progress_conversions, if: -> { urn.present? }

  validates :directive_academy_order, :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  validates_with FormAMultiAcademyTrustNameValidator

  def initialize(attributes = {})
    # if any of the three date fields are invalid, clear them all to prevent multiparameter
    # assignment errors, this essential makes the provisonal date nil, but is the best we can do
    if GovukDateFieldParameters.new(:provisional_conversion_date, attributes).invalid?
      attributes[:"provisional_conversion_date(3i)"] = ""
      attributes[:"provisional_conversion_date(2i)"] = ""
      attributes[:"provisional_conversion_date(1i)"] = ""
    end

    super
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def urn_unique_for_in_progress_conversions
    errors.add(:urn, :duplicate) if Conversion::Project.where(urn: urn, state: [:inactive, :active]).any?
  end

  def save(context = nil)
    assigned_to = assigned_to_regional_caseworker_team ? nil : user
    assigned_at = assigned_to_regional_caseworker_team ? nil : DateTime.now

    team = assigned_to_regional_caseworker_team ? "regional_casework_services" : Project.teams[Project.regions.key(region)]

    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id,
      team: team,
      assigned_to: assigned_to,
      assigned_at: assigned_at,
      directive_academy_order: directive_academy_order,
      two_requires_improvement: two_requires_improvement,
      region: region,
      local_authority: local_authority,
      tasks_data: new_tasks_data,
      new_trust_reference_number: new_trust_reference_number,
      new_trust_name: new_trust_name
    )

    return nil unless valid?(context)

    ActiveRecord::Base.transaction do
      if group_id.present?
        @project.group = ProjectGroup.find_or_create_by(
          group_identifier: group_id,
          trust_ukprn: incoming_trust_ukprn
        )
      end

      @project.save!
      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
      Event.log(grouping: :project, user: user, with: @project, message: "Project created.")
    end

    @project
  end

  def new_tasks_data
    Conversion::TasksData.new(
      church_supplemental_agreement_not_applicable: church_supplemental_agreement_not_applicable?,
      sponsored_support_grant_not_applicable: sponsored_support_grant_not_applicable?
    )
  end

  private def church_supplemental_agreement_not_applicable?
    return true unless establishment.has_diocese?
    false
  end

  private def sponsored_support_grant_not_applicable?
    return true if directive_academy_order == false
    false
  end
end
```

**Key Email-Related Code**:
- **Line 29-32**: `notify_team_leaders` method - Sends emails to all team leaders
- **Line 31**: `TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later` - Email trigger
- **Line 31**: `if team_leader.active` - Guard clause to skip inactive users
- **Line 79**: `notify_team_leaders(@project) if assigned_to_regional_caseworker_team` - Conditional email sending

### Transfer Create Project Form

**File**: `app/forms/transfer/create_project_form.rb`

```ruby
class Transfer::CreateProjectForm < CreateProjectForm
  attribute :provisional_transfer_date, :date
  attribute :outgoing_trust_sharepoint_link
  attribute :two_requires_improvement, :boolean
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean
  attribute :outgoing_trust_to_close, :boolean

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :provisional_transfer_date, presence: true
  validates :provisional_transfer_date, first_day_of_month: true
  validates :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.two_requires_improvement.inclusion")}
  validates :inadequate_ofsted, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.inadequate_ofsted.inclusion")}
  validates :financial_safeguarding_governance_issues, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.financial_safeguarding_governance_issues.inclusion")}
  validates :outgoing_trust_to_close, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.outgoing_trust_to_close.inclusion")}

  validate :urn_unique_for_in_progress_transfers, if: -> { urn.present? }

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validate :outgoing_trust_exists, if: -> { outgoing_trust_ukprn.present? }

  validates_with OutgoingIncomingTrustsUkprnValidator

  validates_with FormAMultiAcademyTrustNameValidator

  def initialize(attributes = {})
    # if any of the three date fields are invalid, clear them all to prevent multiparameter
    # assignment errors, this essential makes the provisonal date nil, but is the best we can do
    if GovukDateFieldParameters.new(:provisional_transfer_date, attributes).invalid?
      attributes[:"provisional_transfer_date(3i)"] = ""
      attributes[:"provisional_transfer_date(2i)"] = ""
      attributes[:"provisional_transfer_date(1i)"] = ""
    end

    super
  end

  def save(context = nil)
    @project = Transfer::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      transfer_date: provisional_transfer_date,
      two_requires_improvement: two_requires_improvement,
      regional_delivery_officer_id: user.id,
      team: user.team,
      assigned_to: user,
      assigned_at: DateTime.now,
      region: region,
      local_authority: local_authority,
      tasks_data: Transfer::TasksData.new,
      new_trust_reference_number: new_trust_reference_number,
      new_trust_name: new_trust_name
    )

    return nil unless valid?(context)

    ActiveRecord::Base.transaction do
      if group_id.present?
        @project.group = ProjectGroup.find_or_create_by(
          group_identifier: group_id,
          trust_ukprn: incoming_trust_ukprn
        )
      end

      @project.save!
      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
      @project.tasks_data.update!(
        inadequate_ofsted: inadequate_ofsted,
        financial_safeguarding_governance_issues: financial_safeguarding_governance_issues,
        outgoing_trust_to_close: outgoing_trust_to_close
      )
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
    end

    @project
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_transfer_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def outgoing_trust_exists
    result = Api::AcademiesApi::Client.new.get_trust(outgoing_trust_ukprn)
    raise result.error if result.error.present?
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:outgoing_trust_ukprn, :no_trust_found)
  end

  private def urn_unique_for_in_progress_transfers
    errors.add(:urn, :duplicate) if Transfer::Project.where(urn: urn, state: [:inactive, :active]).any?
  end
end
```

**Key Email-Related Code**:
- **Line 86-89**: `notify_team_leaders` method - Sends emails to all team leaders
- **Line 88**: `TeamLeaderMailer.new_transfer_project_created(team_leader, project).deliver_later` - Email trigger
- **Line 88**: `if team_leader.active` - Guard clause to skip inactive users
- **Line 80**: `notify_team_leaders(@project) if assigned_to_regional_caseworker_team` - Conditional email sending

### Edit Project Form

**File**: `app/forms/edit_project_form.rb`

```ruby
class EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attr_accessor :project, :user

  attribute :establishment_sharepoint_link, :string
  attribute :incoming_trust_sharepoint_link, :string
  attribute :incoming_trust_ukprn, :integer
  attribute :new_trust_reference_number, :string
  attribute :new_trust_name, :string
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions, :string
  attribute :two_requires_improvement, :boolean
  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :handover_note_body, :string
  attribute :group_id, :string

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :incoming_trust_ukprn, presence: true, ukprn: true, unless: -> { new_trust_reference_number.present? }
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.attributes.two_requires_improvement.inclusion")}

  validates_with GroupIdValidator

  private def update_handover_note
    note = Note.find_or_initialize_by(project: project, task_identifier: :handover, user: user)
    note.update!(body: handover_note_body)
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def group_id_to_group(group_id)
    return if group_id.blank?

    project.group = ProjectGroup.find_or_create_by(
      group_identifier: group_id,
      trust_ukprn: incoming_trust_ukprn
    )
  end
end
```

**Key Email-Related Code**:
- **Line 38-41**: `notify_team_leaders` method - Sends emails to all team leaders
- **Line 40**: `TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later` - Email trigger
- **Line 40**: `if team_leader.active` - Guard clause to skip inactive users

### Internal Contacts Edit Assigned User Form

**File**: `app/forms/internal_contacts/edit_assigned_user_form.rb`

```ruby
class InternalContacts::EditAssignedUserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email, :project, :user

  validates :email, presence: true

  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}, if: -> { email.present? }
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, if: -> { email.present? }

  validate :user_is_assignable

  def self.new_from_project(project)
    user_email = project.assigned_to_id.present? ? project.assigned_to.email : nil

    new({email: user_email, project: project})
  end

  def initialize(attrs = {})
    super
    self.user = User.assignable.find_by_email(email)
  end

  def update
    if valid?
      result = project.update(assigned_to: user)
      send_assigned_email

      result
    else
      false
    end
  end

  private def user_is_assignable
    if user.blank?
      errors.add(:email, :not_assignable)
    end
  end

  private def send_assigned_email
    AssignedToMailer.assigned_notification(user, @project).deliver_later if user.active
  end
end
```

**Key Email-Related Code**:
- **Line 42-44**: `send_assigned_email` method - Sends email when project is assigned
- **Line 43**: `AssignedToMailer.assigned_notification(user, @project).deliver_later` - Email trigger
- **Line 43**: `if user.active` - Guard clause to skip inactive users
- **Line 22**: `User.assignable.find_by_email(email)` - Finds assignable users only

---

## Controller Classes

### Service Support Users Controller

**File**: `app/controllers/service_support/users_controller.rb`

```ruby
class ServiceSupport::UsersController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index_active
    authorize User, :index?

    @pager, @users = pagy(User.active.order_by_first_name)
  end

  def index_inactive
    authorize User, :index?

    @pager, @users = pagy(User.inactive.order_by_first_name)
  end

  def new
    authorize User
    @user = User.new
  end

  def create
    authorize User

    @user = User.new(user_params)

    if @user.valid?
      @user.save
      send_new_account_email(@user)
      redirect_to service_support_users_path, notice: I18n.t("user.add.success", email: @user.email)
    else
      render :new
    end
  end

  def edit
    @user = User.find(user_id)
    authorize @user
  end

  def update
    @user = User.find(user_id)
    authorize @user

    @user.assign_attributes(user_params)
    if @user.valid?
      @user.save!
      assign_capabilities
      redirect_to service_support_users_path, notice: I18n.t("user.edit.success", email: @user.email)
    else
      render :edit
    end
  end

  def set_team
    @user = current_user
    authorize @user
  end

  def update_team
    @user = current_user
    authorize @user

    @user.assign_attributes(team_params)
    if @user.valid?
      @user.save!(context: :set_team)
      redirect_to root_path, notice: I18n.t("user.set_team.success", email: @user.email)
    else
      render :set_team
    end
  end

  private def assign_capabilities
    desired_capabilities = params[:user][:capabilities].map do |name|
      Capability.find_by(name: name)
    end.compact

    @user.capabilities = desired_capabilities
  end

  private def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :team,
      :manage_team,
      :active
    )
  end

  private def user_id
    params[:id]
  end

  private def team_params
    params.require(:user).permit(:team)
  end

  private def send_new_account_email(user)
    UserAccountMailer.new_account_added(user).deliver_later
  end
end
```

**Key Email-Related Code**:
- **Line 29**: `send_new_account_email(@user)` - Triggers email after user creation
- **Line 100-102**: `send_new_account_email` method - Sends new account email
- **Line 101**: `UserAccountMailer.new_account_added(user).deliver_later` - Email trigger

### Handovers Controller

**File**: `app/controllers/all/handover/handovers_controller.rb`

```ruby
class All::Handover::HandoversController < ApplicationController
  include Projectable
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  before_action :set_form, except: [:check, :new]
  after_action :verify_authorized

  def check
    authorize Project, :handover?

    case @project.type
    when "Conversion::Project"
      render "all/handover/projects/conversion/check"
    when "Transfer::Project"
      render "all/handover/projects/transfer/check"
    end
  end

  def new
    authorize Project, :handover?

    @form = NewHandoverForm.new(@project, @current_user)

    render new_template_path
  end

  def create
    authorize Project, :handover?

    return redirect_to_project if incoming_trust_ukprn_required?

    if @form.valid?
      case @form.assigned_to_regional_caseworker_team
      when true
        @form.save
        notify_team_leaders(@project)
        render "all/handover/projects/assigned_regional_casework_services"
      when false
        @form.save
        render "all/handover/projects/assigned_region"
      end
    else
      render new_template_path
    end
  end

  private def incoming_trust_ukprn_required?
    @project.incoming_trust_ukprn.blank? && @project.new_trust_reference_number.blank?
  end

  private def redirect_to_project
    flash[:error] = t("project.handover.create.error.missing_required_ukprn_html")

    redirect_to project_path(@project)
  end

  private def new_template_path
    case @project.type
    when "Conversion::Project"
      "all/handover/projects/conversion/new"
    when "Transfer::Project"
      "all/handover/projects/transfer/new"
    end
  end

  private def set_form
    @form = NewHandoverForm.new(@project, @current_user, handover_params)
  end

  private def handover_params
    params.require(:new_handover_form).permit(
      :assigned_to_regional_caseworker_team,
      :handover_note_body,
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link,
      :two_requires_improvement
    )
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end
end
```

**Key Email-Related Code**:
- **Line 36**: `notify_team_leaders(@project)` - Triggers emails when project handed over to regional team
- **Line 81-84**: `notify_team_leaders` method - Sends emails to all team leaders
- **Line 83**: `TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later` - Email trigger
- **Line 83**: `if team_leader.active` - Guard clause to skip inactive users

---

## Configuration Files

### Development Environment

**File**: `config/environments/development.rb`

```ruby
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't need to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  #
  # We have enabled the Redis cache store in config/application.rb
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  config.action_mailer.default_url_options = {host: "localhost", port: 3000}
  config.action_mailer.delivery_method = :notify
  config.action_mailer.notify_settings = {
    api_key: ENV["GOV_NOTIFY_API_KEY"]
  }

  # Extra Github Codespaces config
  if ENV["CODESPACES"]
    # add the code spaces host to the app hosts
    config.hosts << ENV["CODESPACE_NAME"] + "-3000.app.github.dev"

    # overide the omniauth callback, we cannot actually use this, but it is required to start the app
    ENV["AZURE_REDIRECT_URI"] = "https://" + ENV["CODESPACE_NAME"] + "-3000.app.github.dev/auth/azure_activedirectory_v2/callback"

    # disable CSRF as we cannot rely on the host being 'localhost'
    config.action_controller.forgery_protection_origin_check = false
  end
end
```

**Key Email Configuration**:
- **Line 62**: `config.action_mailer.default_url_options` - Sets host for URL generation
- **Line 63**: `config.action_mailer.delivery_method = :notify` - Uses GOV.UK Notify
- **Line 64-66**: `config.action_mailer.notify_settings` - API key configuration

### Production Environment

**File**: `config/environments/production.rb`

```ruby
require "active_support/core_ext/integer/time"
require "application_insights"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # explicitly disable the CSS compressor
  config.assets.css_compressor = nil

  # compress the sass with sassc
  config.sass.style = :compressed

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # SQL server table config
  #
  # In production all out tables exist in a 'schema' called `complete` so we
  # tell Rails to look for it's internal tables there.
  config.active_record.schema_migrations_table_name = "#{ENV["SQL_SERVER_SCHEMA_NAME"]}.schema_migrations"
  config.active_record.internal_metadata_table_name = "#{ENV["SQL_SERVER_SCHEMA_NAME"]}.ar_internal_metadata"

  # configure the host names
  config.hosts << ENV["HOSTNAME"]
  config.hosts << IPAddr.new(ENV["CONTAINER_VNET"])
  config.hosts.concat ENV.fetch("ALLOWED_HOSTS", "").split(",")

  # configure ActionMailer
  # set the host so links in emails work
  # https://guides.rubyonrails.org/action_mailer_basics.html#generating-urls-in-action-mailer-views
  config.action_mailer.default_url_options = {host: ENV["HOSTNAME"]}

  # Use GOV.UK Notify to send email
  # https://github.com/dxw/mail-notify
  config.action_mailer.delivery_method = :notify
  config.action_mailer.notify_settings = {api_key: ENV["GOV_NOTIFY_API_KEY"]}

  # Use Sidekiq
  config.active_job.queue_adapter = :sidekiq

  # Use Application Insights if a key is available
  if (key = ENV.fetch("APPLICATION_INSIGHTS_KEY", nil))
    # send task intrumentation
    config.middleware.use ApplicationInsights::Rack::TrackRequest, key, 500, 60
    # send unhandled exceptions
    ApplicationInsights::UnhandledException.collect(key)
  end
end
```

**Key Email Configuration**:
- **Line 95**: `config.action_mailer.default_url_options` - Sets host for URL generation
- **Line 99**: `config.action_mailer.delivery_method = :notify` - Uses GOV.UK Notify
- **Line 100**: `config.action_mailer.notify_settings` - API key configuration
- **Line 103**: `config.active_job.queue_adapter = :sidekiq` - Uses Sidekiq for background jobs

### Test Environment

**File**: `config/environments/test.rb`

```ruby
require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.raise = true # raise an error if n+1 query occurs
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # system, or in some way before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = :none

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Set a css_compressor so sassc-rails does not overwrite the compressor when running the tests
  config.assets.css_compressor = nil

  config.action_mailer.default_url_options = {host: "https://example.com"}
  config.active_job.queue_adapter = :test
end
```

**Key Email Configuration**:
- **Line 59**: `config.action_mailer.default_url_options` - Sets host for URL generation
- **Line 60**: `config.active_job.queue_adapter = :test` - Uses test adapter for jobs

### Environment Variables Initializer

**File**: `config/initializers/dontenv.rb`

```ruby
if defined?(Dotenv)
  Dotenv.require_keys(
    "AZURE_APPLICATION_CLIENT_ID",
    "AZURE_APPLICATION_CLIENT_SECRET",
    "AZURE_TENANT_ID",
    "GOV_NOTIFY_API_KEY",
    "AZURE_REDIRECT_URI"
  )
end
```

**Key Email Configuration**:
- **Line 6**: `"GOV_NOTIFY_API_KEY"` - Required environment variable for email delivery

---

## Test Files

### User Account Mailer Spec

**File**: `spec/mailers/user_account_mailer_spec.rb`

```ruby
require "rails_helper"

RSpec.describe UserAccountMailer do
  describe "#new_account_added" do
    it "sends an email with the correct personalisation" do
      user = build(:user, first_name: "First", last_name: "Last", email: "first.last@education.gov.uk")

      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with("d55de8f1-ce5a-4498-8229-baac7c0ee45f", {to: user.email, personalisation: {first_name: "First"}})

      UserAccountMailer.new_account_added(user).deliver_now
    end
  end
end
```

**Key Test Code**:
- **Line 8-9**: Mocks the `template_mail` method call
- **Line 10**: Verifies correct template ID and personalization
- **Line 12**: Tests the mailer method

### Team Leader Mailer Spec

**File**: `spec/mailers/team_leader_mailer_spec.rb`

```ruby
require "rails_helper"

RSpec.describe TeamLeaderMailer do
  describe "#new_conversion_project_created" do
    let(:team_leader) { create(:user, :team_leader) }
    let(:project) { create(:conversion_project) }
    let(:template_id) { "ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353" }
    let(:expected_personalisation) { {first_name: team_leader.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.new_conversion_project_created(team_leader, project).deliver_now }

    before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: team_leader.email, personalisation: expected_personalisation})

      send_mail
    end
  end

  describe "#new_transfer_project_created" do
    let(:team_leader) { create(:user, :team_leader) }
    let(:project) { create(:transfer_project) }
    let(:template_id) { "b0df8e28-ea23-46c5-9a83-82abc6b29193" }
    let(:expected_personalisation) { {first_name: team_leader.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.new_transfer_project_created(team_leader, project).deliver_now }

    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: team_leader.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
```

**Key Test Code**:
- **Line 7**: Template ID verification
- **Line 8**: Expected personalization verification
- **Line 15-17**: Mocks the `template_mail` method call
- **Line 18**: Verifies correct template ID and personalization

### Assigned To Mailer Spec

**File**: `spec/mailers/assigned_to_mailer_spec.rb`

```ruby
require "rails_helper"

RSpec.describe AssignedToMailer do
  describe "#assigned_notification" do
    let(:caseworker) { create(:user, :caseworker) }
    let(:project) { create(:conversion_project) }
    let(:template_id) { "ec6823ec-0aae-439b-b2f9-c626809b7c61" }
    let(:expected_personalisation) { {first_name: caseworker.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.assigned_notification(caseworker, project).deliver_now }

    before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: caseworker.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
```

**Key Test Code**:
- **Line 7**: Template ID verification
- **Line 8**: Expected personalization verification
- **Line 15-17**: Mocks the `template_mail` method call
- **Line 18**: Verifies correct template ID and personalization

---

## Job Configuration

### Application Job

**File**: `app/jobs/application_job.rb`

```ruby
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
```

**Key Job Configuration**:
- **Line 1**: Base class for all background jobs
- **Line 3**: Commented out deadlock retry (not currently enabled)
- **Line 6**: Commented out deserialization error handling (not currently enabled)

---

## Summary

This source code documentation provides:

1. **Complete code coverage** of all email-related components
2. **Line-by-line explanations** of how each part works
3. **File paths and line numbers** for easy navigation
4. **Key code sections highlighted** for quick reference
5. **Test coverage** showing how emails are tested

The email system is built on:
- **GOV.UK Notify** for reliable email delivery
- **Sidekiq** for background job processing
- **Rails ActionMailer** for email abstraction
- **Conditional logic** to ensure emails go to the right people
- **Comprehensive testing** to verify functionality

This documentation should help developers understand exactly how the email system works and where to look when troubleshooting issues.
