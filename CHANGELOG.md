# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Users can add, edit, and delete task level notes. These are displayed on the
  task page.

### Changed

- Only project level notes are shown on the notes page.
- The back link destination is the task page for task level notes, or the notes
  page for project level notes.

## [Release 5][release-5]

### Changed

- Fixed worklow for the test deployment
- "Complete" tag now reads "Completed"

## [Release 4][release-4]

### Added

- The Handover/new project form collects the advisory board date and any
  conditions.
- Users can be assigned to projects roles via 'change' links on the project
  information page. Only users with the team lead role can assign users.
- The Handover/new project form collects an establishment SharePoint link.
- The Project Details section of the Project Information shows the establishment
  SharePoint link.
- The Project Summary shows the establishment SharePoint link.

### Changed

- Lists of users are now sorted by first name.
- Display an "Email" link for users in the actions of the project details
  section. The user's display name is now their name only (email address
  removed).
- Change the project information page to a one-quarter three-quarter layout to
  allow more room for the project information.
- Updated content for the tasks in the 'Get ready for opening' section.
- The "Not applicable" checkbox now sits at the top of the Task view, underneath
  the Task-level hint.
- User assignment drop-downs and autocomplete components show the user's full
  name and email address.
- Users first name and last name are now required. Any fallbacks, which show the
  user's email address when first name and last name are absent, have been
  removed.
- Tasks within Clear Legal Documents section now make use of subheadings to
  better separate logical sections of work.

### Fixed

- The accessible autocomplete component now uses the GDS Transport font to match
  the rest of the service.

### Removed

- There is no longer an edit project page. Instead, roles will be assigned on
  specific assignment pages.

## [Release 3][release-3]

### Added

- Add a bulk user import Rake task.
- Collect Azure Active Directory User ID on sign in.
- The school diocese name is shown on project details or not applicable.
- Selecting a caseworker will now offer to autocomplete if the user has
  Javascript enabled
- The date and time that a caseworker is first assigned to a project is
  recorded. Any subsequent assignments will not be recorded.
- Contacts can be deleted via a button on the edit contact page.
- Show the region on the project summary and school details.
- Notes can be edited by the user who created them
- Notes can be deleted by the user who created them
- Added richer documentation for the workflow schemas
- Added new `subheading` action type to support breaking a task into smaller
  logical sections.

### Changed

- Show the full name alongside email address for users in the Project Details
  section of the Project Information. Users without a full name will continue to
  show email only.
- Show the full name of the note author if available. If it is not available,
  fall back to showing the email address.
- Add an optional "Handover comments" input to the new project form. This will
  create the first project note.
- The caseworker role is no longer implied from the lack of any other roles.
  Instead, users must be explicitly given the caseworker role.
- Improved the layout of the new project page.
- Improve the layout of the task page.
- Update the content for the "Project kick-off" section of the task list.
- Note bodies are parsed via Markdown to allow rich formatting.
- Workflow definition files are now split by section, rather than being
  monolithic.
- Trust names are now displayed in title case, rather than all caps.

### Fixed

- Tasks that have actions without hint text can now be rendered.
- Links on the task list now open in a new tab.
- The name and email address of assigned users is shown on the project
  information tab.
- Workflow validity checks now correctly enforce limits on guidance text,
  minimum number of actions and additional properties.

## [Release 2][release-2]

### Added

- The project information view displays the school type, phase of education, and
  age range.
- The project information view displays the team lead.
- Users must provide the UKPRN of the incoming trust when creating a project.
- The project information view has a Trust details section, which displays the
  incoming trust name, UKPRN, and Companies House number.
- Users must provide the target completion date when creating a project.
- Users can add notes to a project, and view previous project notes.
- Show the school type, target completion date, trust name, and local authority
  name for each project on the projects index page.
- Project contacts can be added and edited
- Add hint text and guidance text to actions.
- A regional delivery officer must be selected at the time of project creation.
- A regional delivery officer can only see project they are assigned to on the
  projects index page.
- Add hint text and guidance text to tasks.
- Optional tasks can be marked 'Not applicable' to the project
- Added content to Articles of association task
- Added content to Church supplementary agreement
- Added content to Deed of variation
- Added content to Direction to transfer
- Added content to Land questionnaire
- Added further guidance to Land questionnaire after more info from UR
- Added further guidance to Direction to transfer after more infor from UR
- Added content to Land registry title plans
- Added content to Master funding agreement
- Added content to Supplementary funding agreement
- Added content for Handover with Regional delivery officer task
- Added content for intro emails in External kick-off task
- Added content for local authority actions for proforma and conversion date in
  external kick-off section
- Added content for arranging kick-off meeting action
- Added content for hosting kick-off meeting action
- Adding content for share conversion checklist action
- Added content for Process conversion grant actions - check vendor account
- Added content for grant eligibility action
- Added link to conversion checklist
- Added content for receive and save Grant payment form action
- Added content for sending documents to grant payment team action
- Added content for confirm grant payment date with schoo action
- Added content for checking school has received grant action
- Project contacts can be grouped by the institution they belong to
- Action hint text is parsed via Markdown to allow rich formatting

### Removed

- No longer show the assigned delivery officer on the projects index page.
- Task list sections are no longer numbered.

### Changed

- Improvements to the text inputs and hints on the new project form to make
  clearer what is expected from users.
- Improvements to the existing error messages on the new project form and new
  notes form.
- Update the conversion workflow, Clear legal documents task list
- The task list is now referred to as "Task list" not "Project task list"
- Rename any references of "Delivery officer" to "Caseworker". Projects will
  lose any currently assigned delivery officers.
- Add validation that checks URN is 6 digits long.
- Add validation that checks UKPRN is 8 digits long and starts with a 1.
- Add validation that checks the target completion date is in the future when a
  new project is created.
- a Team lead can no longer create a new project, it is the responsibility of
  the Regional delivery officer to do so.
- Removed word funding from Church supplemental agreement hint text link to make
  sure naming is consistent and accurate
- Deleteing previous versions of external stakeholder tasks
- Changed content mentioning Supplementary funding agreement to Supplemental
  funding agreement so it is accurate
- Added content to Trust modification order
- Removed duplicate Trust modification order
- Correcting Regional Delivery officer to lowercase

## [Release 1][release-1]

### Added

- Users can sign in to the application using a DfE Microsoft account
- A new conversion project can be started by entering a valid URN of a school
  currently undergoing conversion
- A list of all tasks for a conversion project is displayed
- Actions within a task can be marked as done, and the status of the task is
  updated
- Projects display a summary of key information
- The Project Information view displays further information about each project
- Users can be assigned to each project as a delivery officer
- The team leader who creates a new project is automatically marked as the
  project's team leader

[unreleased]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-5...HEAD
[release-5]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-4...release-5
[release-4]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-3...release-4
[release-3]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-2...release-3
[release-2]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-1...release-2
[release-1]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/releases/tag/release-1
