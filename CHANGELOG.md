# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

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
- Changed content mentioning Supplementary funding agreement to Supplemental
  funding agreement so it is accurate
- Added content to Trust modification order
- Removed duplicate Trust modification order
- Added content for Handover with Regional delivery officer task
- Added content for intro emails in External kick-off task
- Added content for local authority actions for proforma and conversion date
  in external kick-off section
- Added content for arranging kick-off meeting action
- Added content for hosting kick-off meeting action
- Correcting Regional Delivery officer to lowercase
- Adding content for share conversion checklist action
- Deleteing previous versions of external stakeholder tasks
- Added content for Process conversion grant actions - check vendor account
- Added content for grant eligibility action
- Added link to conversion checklist
- Added content for receive and save Grant payment form action
- Added content for sending documents to grant payment team action
- Added content for confirm grant payment date with schoo action

### Removed

- No longer show the assigned delivery officer on the projects index page.

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
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/commits/develop/compare/release-1...HEAD
[release-1]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/releases/tag/release-1
