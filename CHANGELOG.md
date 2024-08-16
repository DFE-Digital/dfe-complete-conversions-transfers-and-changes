# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased][unreleased]

### Added

- a new 'confirm the headteacher contact' task has been added, users need to
  choose the appropriate contact from those available to the project, they may
  also have to add it
- transfer project also have a new 'confirm the headteacher contact' task that
  works the same as for conversions.
- the confirmed headteacher contact details are now included in exports where
  needed.
- a new task 'confirm the chair of governors' task has been added to conversion
  projects, users must supply and indicate which contact fills this role.
- a new 'confirm the incoming trust CEO contact' task has been added to
  conversion projects, users need to choose the appropriate contact from those
  available to the project, they may also have to add it
- a new 'confirm the incoming trust CEO contact' task has been added to transfer
  projects, users need to choose the appropriate contact from those available to
  the project, they may also have to add it
- the confirmed incoming trust CEO contacts now appear in export where
  appropriate.
- a new 'confirm the outgoing trust CEO contact' task has been added to transfer
  projects, users need to choose the appropriate contact from those available to
  the project, they may also have to add it
- the confirmed outgoing trust CEO contact details are now included in the
  export where appropriate.

## [Release-82][release-82]

### Added

- new conversion projects now collect the group reference number, used in the
  Prepare application to group projects together for advisory board.
- new transfer projects now collect the group reference number, used in the
  Prepare application to group projects together for advisory board.
- the group reference number for a conversion or transfer can now be changed
  from the project information view.
- show an indicator when a project is part of a group
- a new index page listing all grouped projects
- a list of the project groups is shown on the index page
- individual project groups can now be viewed

### Fixed

- the time for a date history item is now shown in the London timezone

### Changed

- The feedback form link in the phase banner is now the same as the one in the
  footer

## [Release-81][release-81]

### Added

- The "project main contact" (selected via a task) is output to the RPA/SUG
  export

### Changed

- content changes to articles of association task in conversions and transfers
  to describe the process more accurately
- addition of 1 checkbox to articles tasks in conversions and transfers
- the all project by trust view now includes 'form a multi academy trusts'

## [Release-80][release-80]

### Added

- details component and content to explain when to use a deed of termination to
  end a master funding agreement in a transfer project
- a count of the number of DAO conversion projects has been added to the
  statistics page.

### Changed

- If a project is not assigned to RCS on creation, the assigned user can edit
  the project in the usual way and assign it to RCS, along with adding a
  handover note
- Use of ADOP change to AOPU
- Corrected references in content to the grant payment certificate in
  conversions to declaration of expenditure certificate
- To complete a transfer project users will have to ensure that the following:
  - The transfer date has been confirmed and is in the past
  - The confirm this transfer has authority to proceed task is completed
  - The receive declaration of expenditure certificate task is completed
  - The confirm the date the academy transferred task is completed
- Update the feedback form link in the footer

## [Release-79][release-79]

### Added

- When revoking a DAO, details for each reason must now be supplied.

## [Release-78][release-78]

### Changed

- when changing the significant date for a conversion or transfer project the
  revised date cannot be the same as the current date.
- the project information view now uses 'cards' to break the make the
  information clearer.
- the external contacts are now shown as 'cards' to make them clearer.
- The local authority contact in exports is now the "main" contact as selected
  in the UI. If none is selected, then the exported contact is the next contact
  with the category of "local authority"
- Users are now asked which type of project to add with an explanation of each
  type.

### Added

- Users can now indicate a local authority contact is the local authority main
  contact for a project

## [Release-77][release-77]

### Added

- Add the date an academy opened to the Grant management export for conversions
- Add the team a project is assigned to to the RPA, SUG and FA letters export

### Changed

- The RPA, SUG and FA letter export does not include conversion projects with a
  revoked DAO.
- The by month exports do not include conversion projects with a revoked DAO.
- The single by month view and export are now sorted by the conversion or
  transfer date only.
- The pre conversion grants export includes a new column that shows the DAO
  revocation state of a project as applicable.
- Once a project has it's DAO revoked, it can no longer be edited, except by
  Service Support.
- Conversion projects with a DAO (Directive Academy Order) can now be 'revoked'
  from the task list.
- DAO revocation is a stepped process which requires at least one reason,
  minister name and date of decision.
- Revoking DAO ends a project

### Fixed

- The change conversion date and change transfer date buttons only appear on the
  appropriate project type.

## [Release-76][release-76]

### Added

- The task list includes a link to the completing a project section.

### Fixed

- Corrected the note text created when a user confirms the Transfer date as part
  of the stakeholder kick off task - it said "Conversion" when it should say
  "Transfer"
- Added 'voluntary deferral' to the list of allowed reasons for a change of
  date.

## [Release-75][release-75]

### Added

- Include incoming trust UKPRN in RPA/SUG report
- The project date history view is now available from the project
  sub-navigation.
- The project date history view now includes a section with the current proposed
  or confirmed date called out.

### Changed

- The project date history view (hidden) now uses a 'card' view.
- Extra spacing has been added to the actions buttons for a project
- Any change to the conversion or transfer date now requires a reason and
  details to be provided.

### Fixed

- Service support users can edit completed projects
- The school or academy main contact should now attempt to fetch any
  establishment contacts if the main school contact is not set

## [Release-74][release-74]

### Added

- Microsoft Application Insights browser tracking has been added to the
  application and will only be enabled for users who have opted in to optional
  cookies.
- The by month conversions export now includes the Academy URN and DfE/LAEST
  number.

### Changed

- The academies due to convert export now includes the projects for a supplied
  date range.
- The pre transfer grants export now include the projects for a supplied date
  range.
- The loading time of the by local authority view has been improved, it has to
  load all projects so is still a slow view.
- Content updates to export pages following date picker additions
- The application footer now uses the programme wide layout.

## [Release-73][release-73]

### Changed

- Turn off Parliamentary Members API, do not show any MP details for any
  projects
- The pre conversion grants export now include the projects for a supplied date
  range.

## [Release-72][release-72]

### Fixed

- Do not raise an exception in reports when an establishment is in an unknown
  constituency and the MP details cannot be found.

### Changed

- Ingest two additional fields into Gias::Establishments for PowerBI reporting
  `open_date` and `status_name`
- The RPA, SUG and FA letters export now includes the projects for a supplied
  date range.

## [Release-71][Release-71]

### Added

- A simple POST Api endpoint to create a Form a MAT Conversion project

### Changed

- Changed the "All conditions met" task for Transfers to "Authority to proceed"
- The sponsored grant type column in CSV exports is now labelled 'Project route
  and sponsored grant type' and the value for 'not applicable is now 'Voluntary
  converter - not eligible'.
- The transfer project Form M task is now optional and can be marked as not
  applicable.

### Fixed

- The skip to content link is now underlined.
- Service support users can now edit all contacts.
- URN and UKPRN fields no longer autocomplete.
- When creating a new project and submitting an empty form, the errors are now
  shown correctly.
- If a UKPRN is changed in the Academies DB, handle the exception so that the
  application remains usable for end users
- The academies due to transfer over the next 6 months export index now counts
  transfer projects correctly.

## [Release-70][Release-70]

### Added

- Add the Grape gem and demonstrate a simple Api endpoint in the application
- Add simple authentication to the Api endpoints using an Api key
- Add a task to generate Api keys, along with documentation
- A simple POST Api endpoint to create a Conversion project
- API documentation is now available at /api/docs
- Validation on the new Academy URN so that it cannot be the same as the school
  URN has been added.
- The API does validation of URN and UKPRN on project creation

### Fixed

- When creating a new project, two digit dates are no longer accepted which
  means incorrect dates cannot be submitted.
- The 'complete project' button is no longer shown on completed projects.

### Changed

- URLs pointing links in content to SharePoint guidance updated to new guidance
  pages
- The application fetches establishment and trust data from the new v4 Academies
  API endpoints which should improve performance.
- Service Support users can now update project details and tasks even after the
  project is complete.

## [Release-69][release-69]

### Changed

- The no JavaScript fallback for assigning a user to a project no longer uses a
  select, instead an email address must be entered.
- The autocomplete for assigning a user to a project no longer loads all users
  onto the page, instead it fetches the users as they are typed.
- The no JavaScript fallback for editing the user who added a project no longer
  uses a select, instead an email address must be entered.
- The autocomplete for editing user who added a project no longer loads all
  users onto the page, instead it fetches the users as they are typed.
- The path for changing a project team has changed along with the layout of the
  form for consistency.

### Fixed

- The assigned user autocomplete now works as expected when the project is not
  assigned to a user.
- The edit project team now works for transfer projects as well as conversion
  projects.

## [Release-68][release-68]

### Changed

- Remove the "By month" view under Teams (viewable to users in a regional team
  or RCS only)

## [Release-67][release-67]

### Added

- All in progress projects now includes at tab to view only conversion projects.
- All in progress projects now includes at tab to view only transfer projects.
- All projects in a form a multi academy trust can now be viewed at
  /form-a-multi-academy-trust/<TRN>
- All form a multi academy trust project groups can now be viewed from the All
  projects > In progress > Form a MAT view.

### Changed

- the all in progress projects table has been moved into a tab
- the "Date the academy opened" task is now mandatory in Conversion projects
- If a school phase is "Not applicable" display the school type instead for
  exports

### Fixed

- Broken link to SharePoint guidance in footer and sign-in page now correct
- The margin beneath the sub navigation items is now rendered correctly.

## [Release-66][release-66]

### Changed

- Any project that has a risk protection arrangement of 'commercial' will move
  to in progress until a reason is provided.

## [Release-65][release-65]

### Added

- The reason an academy has taken out commercial risk protection arrangement is
  now included in the exports if available and applicable.

## [Release-64][release-64]

### Added

- Service support users can "soft delete" a project

### Changed

- The 'Add notes for ESFA task' has been disabled as there is evidence that the
  data is never used.
- some tweaks to content in the high needs places tasks to use the correct name
  for the notification of changes to funded high needs places form
- new form a multi-academy trust projects now require the new trust name to
  match any existing values with the same new trust reference number
- The 'confirm the academy's risk protection arrangement' task now includes
  additional guidance about auto enrollment.
- When the 'Confirm the academy's risk protection arrangements' task value is
  exported it is set to 'standard' when the task is incomplete.

## [Release-63][release-63]

### Added

- a new Chair of governors task has been added to the conversion project task
  list, this tasks ensures the contact details are collected
- the chair of governors name and email address are now included in the csv
  export when available
- users can now change the incoming trust UKPRN on a conversion project, this
  allows mistakes to be corrected.
- users can now change the advisory board date and any conditions on a
  conversion project.
- users can now change the academy order type for a conversion project.
- users can now change the conversion due to intervention following 2RI response
  for a conversion project.
- RCS acronym to handover question on add project pages
- Users can now change the outgoing trust UKPRN for a transfer project.
- Users can now change the incoming trust UKPRN for a transfer project.
- Users can now change the advisory board date for a transfer project.
- Users can now change the requires two improvement response for a transfer
  project.
- Users can now change the due to inadequate Ofsted response for a transfer
  project.
- Users can now change the due to financial, safeguarding or governance issues
  response for a transfer project.
- Users can now change the outgoing trust close once this transfer is completed
  response for a transfer project.

### Changed

- all primary buttons are now green instead of blue

## [Release-62][release-62]

### Fixed

- Clear any radio button values in the Sponsored support grant type task if the
  task is later saved as "Not applicable"
- for some projects, an MP name could not be located which caused some views and
  exports to fail, this has been resolved
- typo "receive" replaces 3 instances of "recieve"

### Changed

- the maintenance banner has been repurposed as a more generic information
  banner that can be switched on and off.
- Replace conversion/transfer type wording to be `join a MAT`.

## [Release-61][release-61]

### Added

- Allow service support users to be able to access all exports
- Added guidance to action to send redacts documents to GOV.UK in Redact and
  send documents task for conversions and transfers

### Changed

- Service Support users can now change any of the assignments for a project
- the by month exports now include the provisional conversion and transfer date
  where applicable
- all exports now show provisional conversion or transfer date as applicable
  instead of 'provisional date'
- the projects shown in the 'by month' views and exports no longer contain those
  that were due to convert or transfer in the date range, but are no longer
  going to

## [Release-60][release-60]

### Changed

- the 'academies due to transfer over the next 6 months' export month view has
  been updated inline with the other export views, this also resolve an issue
  where links to the confirmed projects would incorrectly contain conversions

## [Release-59][release-59]

### added

- add ui for "schools due to convert" export, which is replacing esfa & grant
  management and finance exports
- add the new "declaration of expenditure certificate task" to the transfers
  task list
- the "declaration of expenditure certificate date received" is included in the
  "grant management and finance unit" csv export
- the team a project is assigned to is now included in the 'academies due to
  transfer over the next 6 months' export

### changed

- link to trn spreadsheet in add form a mat conversion form opens in new tab
- link to trn spreadsheet in add form a mat transfer form opens in new tab
- temporarily remove the future date validation for confirmed significant dates
- change the export landing page to only show 4 exports (2 each for conversions
  and transfers)

### fixed

- typo in receive grant payment certificate task action fixed - certifcate
  becomes certificate

## [Release-58][release-58]

### Added

- Show the date a conversion happened in the ESFA export

### Changed

- where used, the GOV.UK crown has been updated.

### Fixed

- Get the By Trusts page working again by excluding Form a MAT projects from it.

## [Release-57][release-57]

### Added

- Add button to allow users to create form a MAT conversion projects
- Add a new Form a MAT Transfer create project form
- Show a pink "Form a MAT" label on the project details page if a transfer
  project is a form a MAT project
- A new confirm the date the academy opened task has been added to the
  conversion task list.
- A new confirm the date the academy transferred task has been added to the
  transfer task list.
- Add more contact details to the Funding agreement letters export: School
  contact, Incoming trust contact and "Other" contact
- Show `Form a MAT` or `single transfer` in the exports for Transfer projects
- Add button to allow users to create form a MAT transfer projects
- Show the date a transfer happened in the Grant management export
- The Confirm transfer grant funding level task has been added to transfer
  project task lists
- The Confirm transfer grant funding level value is included in the Grant
  management and finance unit export

## [Release-56][release-56]

### Added

- The ESFA csv export now includes the 'Add notes for ESFA' notes.

### Changed

- Remove maintenance banner for Wednesday 6th March 2024 maintenance
- Temporarily remove the future date validation for the provisional conversion/
  transfer date on project creation
- the Update ESFA data in KIM task no longer mentions KIM, asking users to add a
  task note instead.
- the Add notes for ESFA task can only be completed by providing at least one
  task note and checking the task off.

### Fixed

- Guard against incomplete MP details from the Members API (bugfix from
  production)

## [Release-55][release-55]

### Added

- Show Conversion type (single converter/form a MAT) in the ESFA, Grant
  management and By Month exports, and ensure Form a MAT projects are correctly
  displayed in the export
- the Grant management and Finance Unit conversion csv export now includes the
  grant payment certificate has not been received column
- Add maintenance banner for Wednesday 6th March 2024 maintenance

### Changed

- Academies due to transfer csv export now includes both provisional and
  confirmed projects
- Funding agreement letter csv export now includes both provisional and
  confirmed projects
- ESFA csv export now includes both the provisional and confirmed projects
- Academies due to transfer csv export now includes a provisional date column
- Funding agreement letter csv export now includes a provisional date column
- ESFA csv export now includes a provisional date column
- when the grant payment certificate has not been received, 'unconfirmed' is
  shown in the csv exports that include it, rather than a empty cell

### Changed

## [Release-54][release-54]

### Added

- Add new Conversion "Form a MAT" creation form, as a first pass
- Add a Yes/No column in the "In progress" listing pages to show if a project is
  "Form a MAT" or not.
- the provisional date column is now included in the Grant management and
  finance unit csv export
- Show a pink "Form a MAT" label on the project details page for Form a MAT
  conversions

### Changed

- the Grant management and finance unit csv exports now include both provisional
  and confirmed projects

### Fixed

- the Confirmed/Original date column values are now displayed correctly, with
  the currently confirmed date and the original provisional date shown as
  available
- unassigned projects can now be rendered as csv

## [Release-53][release-53]

### Fixed

- Add missing string for "full sponsored" support grant type in the Conversions
  CSV export
- Return the correct main contact details in the Funding Agreement letters
  export

### Added

- Add more columns to the Academies due to transfer export: School phase, school
  age range, main contact details, school type
- Add Academy UKPRN, School LAESTAB (DfE number) and Academy LAESTAB (DfE
  number) to the Funding agreement letters export
- Add a new By Month view for export/data consumer users. When a user with this
  role clicks on "By Month", they will see a new view with the ability to pick a
  range of dates and see Conversion projects due to convert in that date range
- Add Transfers to the new By Month view for export/data consumer users. This
  view shares the date picker functionality in the change above.
- Add new By Month view for non-data-consumer users. This view shows the next
  (upcoming) month only, and the table has the same columns as the date range
  view described above.
- Add new By Month view for non-data-consumer users. This view shows transfers
  transferring in the next (upcoming) month only, and the table has the same
  columns as the date range view described above.
- Create a By Month CSV export for Conversions
- Create a By Month CSV export for Transfers
- Link the By Month CSV downloads from their respective pages in the UI: By
  Month Conversions & Transfers for data consumers, and By Month Conversions &
  Transfers for non-data consumers

### Changed

- The "By Month" view for data consumers is now a tabbed view of Conversions &
  Transfers (currently only showing Conversions), with different columns in the
  table. There is also a date picker to allow users to choose a date range to
  view.
- Give business support users the ability to view export pages

## [Release-52][release-52]

### Changed

- Extend validation on Advisory board date to make sure the date is not too far
  in the past
- Change "All conditions met" header to "Authority to proceed" for Transfer
  project exports

### Added

- Add a validator to the Conversion project form to ensure the URN of an
  existing academy is not used to start a new Conversion project

## [Release-51][release-51]

### Added

- Service support users can navigate to the GIAS data upload page
- Add additional columns to the ESFA report
- Service support users can now update projects which are assigned to other
  users

### Changed

- When service support adds a new academy URN to a conversion project, the urn
  is now checked against our local record of Establishments, and not the
  Academies API records (which do not contain details for unopened academies)
- Fetch academy details for Conversions from local Gias::Establishment records
  instead of the Academies API. This means we can show details for academies
  which have not opened yet.

## [Release-50][release-50]

### Fixed

- An email is now sent to team leaders when a transfer project is created and
  handed over to Regional casework services
- Fix Conversion project incoming sharepoint link edit view to not display
  outgoing trust sharepoint link field.
- Fix statistics page to show accurate data for Transfer's `by region` table.
- The Sponsored support grant task in Conversions was not completable - fixed

### Added

- Add the ability to download Transfer projects for the Grant management and
  finance team
- Added a field to enter the date a grant payment certificate was received to
  the Conversions Receive grant payment certificate task.
- Script to backfill dates in the Conversions Receive grant payment certificate
  task
- Add Transfer Check and confirm financial information task
- Add the Check and confirm financial information fields to the Grant management
  and finance unit export for Transfers

### Changed

- Changed the existing Grant management and finance team Conversions download
  page to include an information page about the download, and a tabbed view on
  the index page to switch between Transfers and Conversions
- Split the "Check and save" action in the Conversions Receive grant payment
  certificate task. The actions are now "Check" and "Save" separately.

## [Release-49][release-49]

### Changed

- Removed reduced support service banner to the service for the christmas period

## [Release-48][release-48]

### Added

- Add "Business support" as a team option for users.
- Add a CSV export for Academies due to transfer in a time period (this work is
  not publicly viewable)
- Add reduced support service banner to the service for the christmas period
- Build the export journey for Academies due to transfer in a time period
- Build a landing page for all exports, under the Exports tab. This page is
  viewable by all teams who have access to exports.

### Changed

- Move the existing exports into a `conversions` namespace (the urls for these
  pages will now include `conversions` and the downloaded file name will contain
  the word `conversions`)
- Change langauge for `by month` view for all projects to reflect transfers as
  well as conversions.
- Move existing export services into a conversions namespace

## [Release-47][release-47]

### Added

- Add ability to import GIAS groups from csv data
- transfer project now collect if they are a result of 2RI and show this
  information on the about the project tab
- transfer project now collect if they are a result of 2RI and show this
  information on the about the project tab
- transfer projects now collect if they are the result of an inadequate Ofsted
  inspection and show this information on the about the project tab
- transfer projects now collect if they are the result of financial,
  safeguarding or governance issues and who this information on the about
  project tab
- transfer projects now collect if the outgoing trust is expected to close once
  the transfer is completed and this is shown on the about the project tab
- Add a page to allow Grant management and finance unit members to download
  conversion projects by their Advisory board dates. This page is not currently
  linked in the application.
- Add proposed capacity of the academy task to Conversion projects
- Add "Confirm if the bank details for the general annual grant payment to need
  to change" task to Transfer projects
- Add proposed capacity of the academy to the csv export service

### Changed

- Users are not directed to update KIM for the 'Receive grant payment
  certificate' task

## [Release-46][release-46]

### Added

- Enable Search in the UI, add a search box in the header and search results
  view. We can search by:
  - school/academy name
  - school/academy URN
  - incoming trust by UKPRN
  - outgoing trust by UKPRN
- Add `New` project table view for your team projects

## [Release-45][release-45]

### Added

- Allow search by words (establishment name)
- Allow search by GIAS establishment number

## [Release-44][release-44]

### Fixed

- Fix govuk class name for your projects table view from
  `govuk-grid-column-full-width` to `govuk-grid-column-full`

### Added

- Allow service support users to upload GIAS data for asynchronous ingestion
- Content: Adding hint text to transfers supplemental funding task to match
  conversions
- Content: Bullet point guidance to conversion handover notes on add a
  conversion page about SFSO lead's name
- New contacts are imported from the GIAS Establishment data if the required
  fields are present.
- Allow sharepoint links for conversion and transfer projects to be updated and
  changed

### Changed

- Reorder tasks in the "Get ready to transfer" section in the Transfer task
  list.
- The file name used for the GIAS Establishment import data only includes the
  seconds this prevents naming errors.
- Move the Users admin section into the `service-support` namespace
- Content: Transfers handover task tweaks
- Content: Transfers stakeholder kick-off task tweaks
- Content: Add missing T to content in new URN transfers task
- Content: Change to action text in Form M and Land consent letter transfers
  tasks
- Content: Correcting spelling mistake in deed of novation transfers task
- Content: Fixed spelling error in church supplemental and kick-off transfers
  tasks
- Content: School becomes academy in master funding agreement and articles of
  association transfers tasks
- Content: School becomes academy in deed of variation transfers task
- Content: improve grammar in action text for deed of termination for MFA
  transfers task
- Content: improve grammar in action text for deed of termination for CSA
  transfers task
- Content: change "may" to "might" in commercial transfer agreement transfers
  task to improve clairty
- Content: improve grammar in closure declaration transfer task
- Content: correct casing for team names in transfers version of all condition
  met task
- Content: change main contact to primary contact in confirm incoming trusts has
  completed actions transfers task
- Removed any references to Sentry.io
- Changed the "Your projects in progress" page to a table layout
- Change project summary information styling to be consistent across
  applications within the service

## [Release 43][release-43]

### Fixed

- Fix an error that meant outgoing trust UKPRNs were not being properly
  validated for Transfers. We were not checking the outgoing trust actually
  existed.

### Added

- setup a maintenance page

## [Release 42][release-42]

### Added

- Add the "Add new transfer" button for users who can add new projects

### Changed

- Update the "main contact" task content for Conversion and Transfer projects
- Move the site banner environment variable away from sentry and replace with
  our own definded environment variable.

### Fixed

## [Release 41][release-41]

### Added

### Changed

### Fixed

- Production container image switched to `ruby:3.1.4-bullseye` which is built
  against OpenSSL 1.x

## [Release 40][release-40]

### Added

- Add the Main contact task to the Conversion project task list
- Add the Main contact task to the Transfer project task list
- Show the main contact for a project in the project CSV exports
- The all conditions met task for a transfer has updated content.
- Add deeds of termination for MFA task to Transfer projects
- Added the 'Deed of termination for the church supplemental agreement' task to
  transfers.
- The application can now store the un-published GIAS establishment records.
- Allow a contact to be marked as the "establishment main contact"
- Allow a contact to be marked as the "incoming trust main contact"
- Allow a contact to be marked as the "outgoing trust main contact"
- Add missing navigation to the individual (show) export pages
- Add Closure or transfer declaration task to transfers
- Add "Confirm incoming trust has completed all actions" task to transfers
- Add "Redact and send documents" task to transfers
- Add "Request new URN and record" task to transfers

### Changed

- Remove the Funding agreement letters contact task from the Conversion project
  task list
- Change order of the legal tasks in the Transfer task list
- The 'Team projects' section is now 'Your team projects'
- The "School" contact type is now "School or academy"
- Amend the "Your team projects" in progress table view to show either a team
  column or region column depending on whether the current user is a regional
  delivery officer or a regional case worker
- Rework the project summary to contain more concise information.
- Rework the Project information (now called "About the project") tab. Change
  order of some of the information, remove some fields, add 50px spacing between
  each block.
- Update the Your team projects Completed table

### Fixed

- the director of child services is now shown on the external contacts view as
  long as one is available, it is centrall managed and cannot be edited.

## [Release 39][release-39]

### Added

- Every page now has a unique page title
- Add transfer project statistics to statistics page
- Add Transfer project counts to Team > By user view
- Add Land consent letter task to Transfer projects
- Add page titles to Transfer and Conversion project task pages
- Add RPA Policy task to Transfer projects
- Add Form M task to Transfer projects
- Add Church Supplemental Agreement task to Transfer projects
- Add jump links to task lists
- Validate that a transfer's incoming trust is not the same as it's outgoing
  trust
- Show a count of projects added this month on the statistics page

### Changed

- Bring the flash banners in line with GOV.uk styles
- corrected content in action on all conditions met conversion task
- All `opening` URLs are now `by-month`, i.e. `/projects/all/by-month` and
  `/projects/team/by-month`
- The links on the By region table have been moved to the region name column.
- The links on the By user table have been moved to the user name column.
- The links on the By trust table have been moved to the trust name column.
- The links on the By local authority table have been moved to the local
  authority name column.
- The links on the Team By user table have been moved to the user name column.
- Rework the columns on the By month > Confirmed table data
- content changes to the sponsored grant task

### Fixed

- Transfer projects can be assigned to users & teams
- Show Transfers on the all completed projects page, projects added by you page
  and the completed projects by you page
- Don't constrain the banners to a two-thirds section
- Show the correct values for `all_conditions_met?` in the project CSV export

## [Release 38][release-38]

### Added

- Add "Outgoing trust" category to External contacts
- Show user counts by team on the statistics page
- Add a Handover task to Transfer projects
- Add more actions to the Stakeholder kick-off task for Transfers
- Store the DateTime of a user's latest session (the last time they logged in)
- Show the time of the user's latest session in the User table, as "Last seen"
- Add master funding agreement task to Transfer projects
- Add a Deed of novation and variation task to Transfer projects
- Add Articles of Association task to Transfer projects
- Add commercial transfer agreement task to Transfer projects
- Add All conditions met? task to Transfer projects
- Add Supplmental funding agreement task to Transfer projects
- Add Deed of Variation task to Transfer projects

### Changed

- removed erroneous additional s from Address on the project information page
- used details components to chunk up the guidance in the notification of change
  task to improve readability
- removed extra the from notifcation of change task and add a transfer form
- add simple side navigation to the statistics page
- the Director of Child Services contact information is now in the External
  contacts area, not the Local authority information area.
- updated grants team email address
- added C of E/cofe issue to accessibility statement
- do not send any mails to deactivated users
- Amended all table views to be able to display a conversion project as well as
  a transfer project
- Remove the View project column from the table views and make the school name
  link to the project view instead
- corrected some small errors in the transfers master funding agreement task
- updated content in the conversion master funding agreement to match transfers
  version
- added missing full stop to all conditions met task

### Fixed

- The all projects in-progress table is sorted by the conversion or transfer
  date.

## [Release 37][release-37]

### Added

- Early support to view a transfer project, no user facing changes.
- Transfer projects can confirm the transfer date.
- The transfer date is shown in the project summary for transfer projects.
- A transfer project can be completed.
- All three SharePoint links are now shown on the transfer project summary.
- A transfer project can be displayed on the Your in-progress projects view.
- The new transfer project form is now complete and ready for the point transfer
  projects are enabled.

### Changed

- conversions dates changes have been made generic ahead of support for
  transfers, no user facing changes.
- the conversion date is now stored as a more generic significant date ahead of
  support for transfers, no user facing changes.
- the conversion URN tables no longer include the route, school phase or type.
- the statistic page no longer shows voluntary or sponsored project totals.
- the task list is now disaplyed in a narrower layout.
- remove the third checkbox from Receive grant payment certificate task and
  amend the guidance on the first checkbox to be more explicit.
- remove Route from project summaries.
- 'Trust' is now 'Incoming trust' on conversions and transfers.
- The back link on a single conversion project has been removed as it does not
  link back to the expected location in all cases.
- The 'user' path now matches the navigations 'yours'.
- The new conversion button has moved up the page.
- The layout and information shown on the Your in-progress projects view has
  been improved.
- improved content on sign in page to include registraiton, guidance and release
  notes links
- The handover note when adding a new project is only required if you indicate
  that the project will be handed over.
- The order of the new project form fields has been improved.
- All "By" views now include Transfer project counts as well as Conversion
  project counts

### Fixed

- some project sub views now render in a wider layout.
- the outgoing trust UKPRN is now assigned correctly.

## [Release 36][release-36]

### Added

- Add "2RI" question to the new Conversion project form
- Remove hint from the "DAO" question on the create Conversion project form
- Show the "2RI" value on the Project information page
- Add a very basic create form for Transfer projects
- Add a "Handed over" view to Team projects area where projects which have been
  handed over to regional_caseworks_services team can be viewed
- Regional casework services team cannot view the Handed over tab or view

### Changed

- All views that pre fetch data from the Academies API do so via the new method.
- the Opening list now shows the academy order type instead of the route.
- The underlying mechanics for conversion dates has changed to significnat dates
  ahead of adding transfer projects, no user facing changes.

### Fixed

- The DfE frontend javascript is now loaded, the mobile navigation button should
  now work as expected.
- Move pager on the `by trust` view to the bottom of the page

## [Release 35][release-35]

### Added

### Changed

### Fixed

- The Team projects views now work when there are more than twenty projects.

## [Release 34][release-34]

### Added

- Add confirmed and revised Project openers by team

### Fixed

- Limit line lengths to 75 characters after increasing app width to 1200px
- Only show counts of in-progress projects on the Team "By user" projects page
- Send the new user email when an account is added.

## [Release 33][release-33]

### Added

- If your user account is not assigned to a team, you will be asked to choose
  one next time you sign in to the application.
- The team a user is associated with is now shown on the All projects, by team
  view.
- User accounts can now be deactivated which prevents the user from accessing
  the application or from showing up in user selections, inactive accounts can
  be reactivated.
- Add a "Users" view to the Team projects area, to view other users on your
  team, with their conversion project counts.
- Add a "by user" view to the Team projects area, where a user can view projects
  assigned to another user on the same team.

### Changed

- the opening list now prefetches establishment and trust details, improving the
  performance of the view.
- Dates in csv exports are now formated as YYYY-MM-DD.
- The application now uses the DfE Design System fonts.
- The application now uses the DfE Design System header, footer and buttons.
- Change the Team projects views to only show projects aligned to the user's
  team
- Only team leaders can see the Unassigned projects page in the Team projects
  view
- All users with a role and a team can now view the Team projects view
- The users view is now split into active and inactive user accounts.
- The number of pages shown in the pager has been increased to 10
- Updated to Rails 7.0.6

### Fixed

- Users without a team show up as 'No team' in the User management list.
- View with large numbers of projects that batch fetch establishment and trust
  data from the API should now load on pages after page one.

## [Release 32][release-32]

### Added

- Allow users to change a Project's team assignment via the Internal Contacts
  page
- a new view that shows the users in the application
- new users can now be added by service support users of the application
- existing users can now be edited in the application

### Changed

### Fixed

- Allow CSV export to go ahead when a school's parliamentary constituency is
  unclear
- Fix date ordering on project index pages
- the confirmed and revised opening lists now correctly change month

## [Release 31][release-31]

### Added

- Add a rake task to update the `team` attribute on all existing users
- Added a view, by region, that shows the region with in-progress projects
- By region view links to the projects in that region
- Add a rake task to update the `team` attribute on all existing projects
- Added a new view that list users who are assigned to projects, showing the
  number of conversions.
- Added a view that list the projects assigned to a given user.

### Changed

- The opening view no longer shows the status of the direction to transfer or
  trust modification order tasks.
- The all conditions met column on the opening view is no longer shown as a
  coloured tag and is one of Yes or Not yet.
- Update sponsored support grant task to include a new radio button action

### Fixed

## [Release 30][release-30]

### Added

- A view, by trust, that shows the trusts that have in-progress projects in the
  application and lists the projects.
- Add Route and Academy name to the CSV export
- A view, by local authority, that shows the local authorities that have
  in-progress projects in the applicaiton and list those projects.
- The risk protection arrangement task (RPA) to the conversion task list.

### Changed

- Users who do not have a recognised role can no longer add notes or contacts.
- Users who do not have a recognised role can no longer edit contacts.

### Fixed

- Enforce UTF-8 encoding in the CSV download via a BOM (byte order mark) and by
  generating the CSV file in UTF-8

## [Release 29][release-29]

### Added

- Add `outgoing_trust_ukprn` to Transfer::Project model
- The unassigned project table now includes the region a project is in.
- Add a link to the service guidance in the application footer.

### Changed

- All `regional-casework-services` URLs are now `team`, e.g.
  `/projects/team/in-progress`
- Content updated in trust modification order task. Checkbox descriptions now
  accurate. Additional clarifications added to guidance.
- Content updated in direction to transfer task. Checbox descriptions now
  accurate. Additional clarifications added to guidance.

### Fixed

- A user who has no role is now redirected to the all projects section of the
  application.
- The list of projects with a revised conversion date for the month and year no
  longer includes projects with provisional and confirmed conversion dates that
  do not match.

## [Release 28][release-28]

### Added

- Do not allow a project to be completed until all conditions have been met, the
  grant certificate is returned and the academy has opened
- Header navigation to allow users to move between the main sections of the
  site. The navigation items show refelect the user's role.
- Navigation to the All projects section to allow users to move between in
  progress, completed and statistics views.
- The Opening section is now included in all projects, it shows conversion that
  are due to open in the next calendar month and those that were going to open
  but are no longer.
- Add bare bones Transfer::Project and Transfer::TasksData models
- Create an opening projects csv exporter
- The team projects section now has primary navigation.
- Add remaining attributes to csv for data export for funding agreement letter

### Changed

- the urls that some service support views were found have changed.
- the layout of the statistics page has been updated.
- The service support section now uses primary navigation to allow for more
  logical groupings of views.
- The primary navigation is now shown on all local authority views.

### Fixed

- Redirect the user if they accidentally visit `/projects`

## [Release 27][release-27]

### Added

- Display generated DfE number in project information view for the establishment
- Service support users now see their own sub-navigation in the application

### Changed

- Change the values of the "All conditions met" tag in the openers list, to
  "confirmed" and "unconfirmed"
- Update the column values on the Openers page, and add new tags for the
  Direction to transfer and Trust modification order column values
- Move route of the Openers page to `/projects/all/opening/month/year`
- Move route of the Projects with changed conversion dates to
  `/projects/all/revised-conversion-date/month/year`
- Tie the Openers and Revised conversion date pages together with tabs
- Update content in project creation confirmation page to make clear delivery
  officers must add contacts
- Change primary action button on project creation confirmation page to point to
  external contacts page
- Pull full stop out of mailto link on single worksheet task and into text
- Change primary action button to point to external contacts page
- Add missing full stop to guidance in grant payment certificate task
- Updated the way we present academy name and URN in the conversion date change
  confirmation page so it is consistent with other confirmation pages
- Changed the content on the conversion date change confirmation page to provide
  clearer, more direct guidance about how and when a date can be changed by
  phrasing the heading as a statement and not a question
- Adding a new project where the school is not considered 'religious'
  automatically marks the 'Church supplemental agreement' as not applicable,
  users can make the task applicable if desired
- Adding a new project that has not been issued with a directive academy order
  automatically marks the 'Process the sponsored support grant' task as not
  applicable, users can make the task applicable if desired

### Fixed

## [Release 26][release-26]

### Added

- Add importer to import Director of Child Services data
- a new 'Confirm the academy name' task that collects the confirmed new academy
  name so that the Get information about schools record can be added.
- Add hint text to External contacts tab
- Users can view a list of projects for a given trust

### Changed

- notes associated with a change to the conversion date can no longer be
  deleted, only edited by the user that added them.
- The 'new academy URN' and 'with academy URN' views now include the confirmed
  academy name, this helps servcice support ensure the correct details have been
  added to Get information about schools.
- the handover note added by regional delivery officers when creating a new
  project is now required
- the handover note added by regional delivery officers when creating a new
  project is now associated with the ' Handover with regional delivery officer'
  task
- The site header is now a DfE specific version that links to the Intranet and
  the application.

### Fixed

## [Release 25][release-25]

### Added

- Display trust's Group Identifier within the project information view

- added a new view that can list projects by user
- show the Director of Child Services contact (if one exists) on the project
  information page
- allow the Director of Child Services record to be created/updated alongside
  the Local Authority

### Changed

- content in academy order error message no longer references previous iteration
  of the question

### Fixed

- the 'external stakeholder kick-off' task can now be updated without providing
  a confirmed converison date.
- the back link on the 'Commercial transfer agreement' task is now shown
  correctly

## [Release 24][release-24]

### Added

- a new view that shows regional delivery officers the projects they have
  created
- User can provide the new academy urn once it has be created in Get information
  about schools
- Added a new list of all projects with Academy URNs
- Display local authorities and their details
- Allow local authority records to be edited
- Allow new local authority records to be added
- Allow local authority records to be deleted
- Ensure only the new `service_support` user can create, edit and delete local
  authority records

### Changed

- edit handover comments guidance and remove details component
- when creating a new conversion project, users are asked 'what kind of academy
  order has been issued?' with directive academy order (DAO) or academy order
  (AO) being the responses
- Correct the error messages for Provisional conversion date on the Create
  conversion project form

### Fixed

- when a trust has no companies house number in the database, the project
  information view can still render

## [Release 23][release-23]

### Fixed

- Address subtle bug in Project creation, which meant two projects with the same
  URN were created in error
- Notification banner when users email not recognised is no longer a success
  banner.
- Fixed a bug where the project information page would not load if a Local
  Authority was not found

### Added

- Raise a specific error page if our access to the Academies Api has been
  revoked

### Changed

- update to hint text in external stakeholder kick-off task so content works for
  both sponsored and voluntary conversions
- Corrected Legal Advisor's Office to Legal Adviser's Office in trust
  modification order task checkboxes
- Added new guidance to project creation page so users know to find information
  in the advisory board template
- Updated content in Confirm the school has completed all actions task so that
  it applies to both types of conversion
- Removed the "Tell the Regional Delivery Officer the school has opened" task
- Update content in Share the grant certificate and information about opening
  task to make it appropriate for both conversion types
- Update hint text copy in Receive grant payment certificate to make it
  applicable to both voluntary and sponsored conversions

## [Release 22][release-22]

### Added

- new MembersApi Client to call the Parliamentary Members API and retrieve MP
  details
- show the Member of Parliament details for a school on a new page
- Users can view a project's local authority details from the project
  information tab

### Changed

- stop search engines from crawling the application
- the statistics page includes the counts of unassigned projects, which makes
  the numbers add up

## [Release 21][release-21]

### Fixed

- the link to a project on the openers table now reads 'View Project' not 'html'

### Changed

- standardised capitalisation in redact and send documents task
- removed duplicate content from send redacted docs to funding team to publish
  on gov.uk action in redact and send documents task
- standardised capitalisation in the receive grant payment certificate task

### Added

- a section to project that shows the academy details, currently this will not
  show details until the academy URN is provided
- the academy details will be shown in full once the academy URN is supplied,
  when the academy details cannot be found, a helpful message is shown

## [Release 20][release-20]

### Changed

- remove the use of slip in the all conditions met task
- references to Legal advisers office become Legal Adviser's Office
- the sponsored route is only applied to a project where a directive academy
  order has been issued
- the new project form no longer asks 'Is the school joining a Sponsor trust?'

### Added

- New views at `/projects/regional/in-progress` and
  `/projects/regional/completed` to show projects NOT assigned to Regional
  caseworker services
- New views at `/projects/regional/:region/in-progress` and
  `/projects/regional/:region/completed` to show projects NOT assigned to
  Regional caseworker services, filtered by region
- User can view statistics page for all project statistics

## [Release 19][release-19]

### Added

- a new view at `/projects/all/new` that shows all conversion projects that
  require the new Academy URN to be provided
- a new view that shows projects that were going to convert in the given month
  but have since changed date

### Changed

- Standardised capitalisation in share grant certificate task
- Standardised capitalisation in single worksheet task
- Standardised capitalisation in commercial transfer agreement and tenancy at
  will
- Standardised capitalisation in the church supplemental agreement tasks
- Standardised capitalisation in the master funding agreement tasks
- Standardised capitalisation in supplemental funding agreement voluntary and
  involuntary tasks
- Standardised capitalisation in land registry title plans tasks
- Standardised capitalisation in voluntary and involuntary land questionnaire
- Standardise capitalisation on clear and sign legal documents pt3
- Projects that have no user assigned to them no longer appear in lists of
  in-progress projects
- In-progress projects are not orderd by their converison date, with those
  converting soonest at the top
- Added full stops to project handover confirmation page. Also explicitly called
  out the URN. Removed a from opens in a new tab.
- Projects store the school's region as a first-class attribute
- the 'Handover with regional delivery officer' task is now optional

## [Release 18][release-18]

### Changed

- Standardising capitalisation in the project kick-off tasks
- Improved the summary text on the openers list and added a full stop.
- Made project list tables headings consistent with openers list
- Fulls stops added to empty states messages in project lists
- Corrected guidance in the commercial transfer agreement tasks. It now says
  solicitors, not schools or trusts
- Made Sponsored support grant sentence case, not title case
- Corrected guidance in 125 year lease task. Now tells user to contact
  solicitor, not school
- Updated the dev & test URLs in the README
- users can no longer create a new project with a school URN that already has a
  project in progress, this prevents duplicate projects being created by mistake
- Removed the "Check the baseline" task from task lists
- Conversion projects now have a route of voluntary or sponsored
- A conversion project can now be added on the same day as the advisory board

### Added

- a new view that show all in-progress conversion projects that are sponsored at
  `/projects/all/in-progress/sponsored`
- a new view that show all in-progress conversion projects that are voluntary at
  `/projects/all/in-progress/voluntary`
- a new view that show all completed conversion projects that are sponsored at
  `/projects/all/in-progress/sponsored`
- a new view that show all completed conversion projects that are voluntary at
  `/projects/all/in-progress/voluntary`
- basic telemetery is being sent to DfE Application Insights
- Add a link to the companies house information page from the project
  information tab

### Fixed

- Fixed a bug where every time a task list was saved, a new note was created

## [Release 17][release-17]

### Changed

- Updated success messages for notification banners
- Users who are not assigned to the project can no longer update the task list
  actions
- Users who are not assigned to the project can no longer change the conversion
  date
- Users who are not assigned to the project can no longer complete it
- External contacts can no longer be added, updated of deleted from projects
  that are completed
- Notes can no longer be added, update or deleted from projects that are
  completed
- Tasks can no longer be updated once the project is completed
- Internal contacts can no longer be updated once the project is completed
- The Voluntary Process conversion grant task is now optional
- Remove "Create a new involuntary project" button
- the number of items on tabular views has been increased from 10 to 20
- the sharepoint links have been removed from the Project details section in
  Project information, they are available in the project summary as before
- the advisory board details are now separated form the Project details on
  project information
- when a users should not update a project, the save and continue button is no
  longer shown on the task view
- the unassigned tab has moved to the start for Regional casework services team
  leads
- the Regional casework service team leads now see new views for in progress and
  completed that show all the projects handed over to their team

### Added

- a new view that shows all in-progress projects at `/projects/all/in-progress`
- a new view that shows all in-progress projects assigned to Regional casework
  services at `/projects/regional-casework-services/in-progress`
- a new view that shows all completed projects at `/projects/all/completed`, the
  new view switches to a specific table that is focused on showing completed
  projects which is sorted by completion date
- a new view that shows all completed projects assigned to Regional casework
- a new view that shows a user the project they are assigned and that are
  in-progress at `/projects/user/in-progress`
- a new view that shows a user the project they are assigned and that are
  completed at `/projects/user/completed`
- a new view that shows all projects that have not been assigned to a user, but
  have been assigned to Regional casework services at
  `/projects/regional-casework-services`
- Add Directive academy order radio buttons to Create project form
- Show the project's Directive academy order information in the project
  information tab
- Add Sponsor trust required radio buttons to Create project form
- Show the project's Sponsor trust required information in the project
  information tab
- New Process the Sponsored support grant task added to the Voluntary task list
- when viewing a completed project, a banner is shown to inform users why they
  cannot change the project
- when viewing a project to which users are not assigned, a banner is shown to
  inform users why they cannot change the project

### Fixed

- users can submit changes on the involuntary external stakeholder kick off task
  once the confirmed conversion date is set
- users can submit changes on the voluntary external stakeholder kick off task
  once the confirmed conversion date is set
- the user that prepared the conversion for advisory board is now shown on the
  unassigned projects table
- after creating a new conversion that will be handed over to the regional
  casework services team, the link back to the users projects is now fixed

## [Release 16][release-16]

### Added

- users can now change the conversion date beyond the initial confirmed date
- the conversion date cannot be changed unless it has been confirmed in the
  External stakeholder kick off task
- when changing the conversion date, users now see a confirmation page when the
  change was successful
- Show a tag for a project's "All conditions met?" status in the project openers
  table
- Sort the project openers table by All conditions met = true and then
  establishment name
- the school address from Get information about schools is now shown in the
  school details on the project information tab
- the trust address from Get information about schools is now shown in the trust
  details on the project information tab
- add a Project Openers table view
- Add email validation to the user model

### Changed

- Update to complete project button guidance
- Corrected link and guidance in the volutnary articles of association task.
  Content was already correct in the sponsored version.
- Involuntary/Sponsored > External Stakeholder Kickoff guidance iteration and
  fix incorrect guidance
- Involuntary/Sponsored > External Stakeholder Kickoff > Send introductory
  emails copy changes to improve words and handle faith schools/diocese
- the conversion date can now only be set once on involuntary conversion
  projects, subsequent changes are considered 'slips' and we be handled
  separately and later.
- the conversion date can now only be set once on voluntary conversion projects,
  subsequent changes are considered 'slips' and we be handled separately and
  later.
- Voluntary > External Stakeholder Kickoff > Send introductory emails copy
  changes to improve words and handle faith schools/diocese
- the width of the application has been increased from 960px to 1024px when
  viewed on desktop class device.
- Amended the Confirm all conditions met task content
- Amended the text on the Project completed page
- The Voluntary project creation journey now has two different "endings"
  depending on whether the project is being handed over to Regional Caseworker
  services or not
- Removed the Caseworker and Team Leader fields from the internal contact tab
- Started tracking when a project is assigned to a person via the `assigned_at`
  database column
- the openers list now only shows conversion projects where the conversion date
  has been confirmed i.e. not provisional

## [Release 15][release-15]

### Changed

- the voluntary conversion, stakeholder kick off task had a duplicated action.
  This has now been corrected. Users may want to verify they have completed the
  action in the task.
- renamed the "Contacts" tab to "External contacts"
- moved the Caseworker, Team Leader and Regional Delivery Officer details to a
  new "Internal contacts" tab.
- The notification banner shown to users after a successful operation has a new
  visual style.
- If a voluntary project is being handed over to Regional Casework Services,
  send the team leader notification; if it is not, assign the current user to
  the project and do not send the notification.
- Update Rails to 7.0.4.2 to address some security issues.
- Tasks displayed on the task list are no longer indented.
- The text for the external stakeholder kick off task on the voluntary
  conversion route has been updated, one action removed and the order of the
  actions changed slightly.
- Amend the text for the stakeholder kick off task on the involuntary conversion
  route.

### Added

- group projects in project list by their provisional conversion date
- Any user can now assign a project to any other user, via the "Assign to" row
  on the project's "Internal contacts" tab.
- add healthcheck endpoint
- The form to create a voluntary conversion project allows the user to indicate
  if the project is being handed over to Regional Casework Services
- Add tab for unassigned projects just for team leaders view
- Add a new action "Host stakeholder meeting" to the involuntary stakeholder
  kick-off task
- Add new action Check provisional conversion date to the involuntary
  stakeholder kick-off task
- Add Assign button to projects on the Unassigned projects tab
- Add link to the trust on GIAS from the project information tab

## [Release 14][release-14]

### Changed

- Update hint text and error message for provisional conversion date entry
- the notification banner now has a unique style for when it informs users of a
  successful action.

## [Release 13][release-13]

### Changed

- the order of the contact groups is now as users might expect.
- the name of the cookie used to store a users session has changed. User will be
  asked to sign in after this change.
- cookies page content better reflects the cookies in use.
- the provisional conversion date is now shown as 'Converting on' with a tag to
  show the date is provisional.
- The Stakeholder kick off task now collects a confirmed conversion date. This
  task will become in-progress after this change. Users must supply a value for
  this.
- The conversion date is now shown as either provisional or confirmed.
- The Stakeholder kick off, confirmed conversion date is now validated for
  correct format.

### Added

- Add task generators
- Added a link to the school's information in GIAS on the project information
  page.
- Users can manage optional cookies.
- A Cookie banner is shown on the application to help users understand and
  manage their cookie preferences.
- Google analytics are now used if the user has accepted optional cookies.

## [Release 12][release-12]

### Added

- Completed project page includes a link to the feedback survey
- Solicitor has been added to the contact category options
- Users cannot attempt to submit the 'choose category' option on a new contact
- The order of contacts has been updated, it is now by category and name
- Add 'Organisation' to contacts, users can store an organisation name here

### Changed

- Removed the old tasks & task lists. The editable tasklist YAML files in
  `workflows` are no longer used
- Removed ProjectPresenter from the codebase

## [Release 11][release-11]

### Added

- Users will use the new task list and task backend

### Fixed

- after creating a new project, users are redirected to the correct project page
- links in email notifcations use the correct urls

## [Release 10][release-10]

### Features

#### Added

- Added cookies page to describe how we use cookies
- Send notification to caseworker when assigned to a project
- Add a Content Security Policy
- Completely new task list and task backend.

#### Changed

- Church supplemental guidance link now points to specific guidance rather than
  general model documents page
- Remove check grant amount on voluntary and involuntary routes
- Grant claim form action now includes where the document should be saved
- Voluntary and Involuntary changes to external stakeholder kick-off
- Involuntary & voluntary redact and send agreements copy iterations
- They've becomes they have to follow GDS guidelines
- Remove negative contractions
- Confirm opening date with school becomes Share the grant certificate and
  information about opening with the trust
- Tasks Continue button now states 'Save and return', tests updated too
- Tenancy at will guidance now explains how rarely it is used and that users
  should contact policy team for advice if one is needed. Voluntary &
  involuntary
- Fix broken link to email templates in external stakeholder kick-off task
- Make guidance link content more descriptive of destination in Articles of
  association
- Remove 'with the trust' from Share the grant certificate and information about
  opening task in the voluntary task list as school and trust should be made
  aware here
- Rename Process grants task for involuntary task list to Process the Sponsored
  support grant
- Add actions to the Process the Sponsored support grant task telling user to
  check and confirm the trust's grant eligibility and tell the trust the amount
  they're able to claim
- Support email address changed to regionalservices.rg@education.gov.uk and an
  optional subject line added to the email helper

#### Fixed

- Format workflow yml files so that markdown renders correctly
- When submitting the new project form, blank URNs and UKPRNs will show a
  validation error.
- When resubmitting a create project form which failed validation, the app would
  throw a 500 error.
- When creating a new project, missing or invalid dates will render a validation
  error on the UI with a helpful message to the user.

#### Content

- Fix typo on phase banner feeback becomes feedback
- 125 year lease, subleases, tenancy at will and commercial transfer agreement
  have standardised actions that use the same language

## [Release 9][release-9]

### Features

#### Added

- Write accessibility tests to run axe, the accessibility tool
- First version of a task list for involuntary conversions.
- Renamed the new project button to 'new voluntary conversion project' and added
  the 'new involuntary conversion project' button
- Show the conversion route on projects

#### Changed

- Content iterations to the add project pages including, copy, hints and errors
- Page load speed has been improved on pages that fetch project data from the
  API. The project index page fetches establishments and trusts in bulk.
- Regional team leads are no longer notified upon the creation of an involuntary
  converison project.

#### Fixed

- The "Cancel" link on the new note page takes the user back to the task page if
  the note is a task-level note.
- The text of the "Not applicable" checkboxes is bold to match the other task
  checkboxes.
- The assign user select elements are enhanced with the accessible autocomplete
  component.

### Content

- Iterate content with things we learned from private beta and regional delivery
  officers

## [Release 8][release-8]

### Features

#### Added

- If the Academies API times out, show a custom error page to the user
- Rename the "Target completion date" on a project to "Provisional conversion
  date"
- Set up accessibility tool
- Split the Project index page into two tabs - "In Progress" and "Completed"
  projects
- Set up selenium to work within CI
- add in accessibility page
- footer now have link to accessibility page
- standardise the email the team link based on GOV.UK guidance
- privacy policy page uses service name helper rather than explicit text
- Add environment banner for local development, development and test
  environments.

#### Changed

- Add project now include links to GIAS to help find URN and UKPRN
- Fine-tuned padding for actions in various type/state combinations to closer
  match the prototype.
- The support email has been swapped out for a complete team shared inbox.
- Links styled as buttons are now correctly marked up for accessibility

#### Fixed

- Remove empty links from the task list. These were raised as an issue during an
  accessibility audit, because the assistive technology used was reading out all
  of the blank links.

### Content

- After opening => redact and send task and actions no longer explicitly mention
  funding documents only as other documents may need to be sent and publised on
  GOV.UK
- Tenancy at will adds action to explicitly indicate that the email from the
  school has been received.
- Subleases adds action to explicitly indicate that the email from the school
  has been received.
- Commercial transfer agreement adds action to explicitly indicate that the
  email from the school has been received.
- 125 year lease adds action to explicitly indicate that the email from the
  school has been received.
- Swap out the link to the previous version of the single worksheet for a link
  to an updated version.
- The checkbox label in the "Land questionnaire" task says "Signed by
  solicitor", updated from "Signed by school or trust".
- The "Articles of association" task is now optional.
- Change the guidance link in the "Articles of association" task.
- The "Signed by secretary of state" section has been removed from the "Trust
  modification order" task.
- The "Signed by secretary of state" section has been removed from the
  "Direction to transfer" task.
- The "Commercial transfer agreement" task has been moved to the bottom of the
  "Clear and sign legal documents" section

## [Release 7][release-7]

### Features

#### Added

- The phase banner and link to general feedback form
- Projects can be closed.
- An email is sent via GOV.UK Notify to all team leads when a project is
  created.
- The Handover/new project form collects a trust SharePoint link.
- The trust SharePoint link is shown on the project information.
- The trust SharePoint link is shown on the project summary.
- Closed projects display their closed date on the project list
- Closed projects are sorted to the back of the project list
- Actions can have their padding (between previous action) explicitly reduced
  using the new `padding` parameter.

#### Changed

- The service name has been removed from the Projects page
- The Projects are listed in target completion date order, soonest first
- All tasks in the workflow definition files must now include a `slug`
  parameter.
- 404 errors will show a GOV.UK style page in production.
- 500 errors will show a GOV.UK style page in production.

### Content

- Commercial transfer agreement added to legal docs
- Added 125 year lease to clear legal docs section
- Add subleases task to legal documents section
- Add Tenancy at will task to the legal documents section
- Content changes to EFSA in KIM to combine 2 bullet points
- Remove the Handback with regional delivery officer task
- Tell regional delivery that the academy has opened task to Project close
  section
- Project close section renamed After opening
- Content changes to Land questionnaire
- Content changes to Master funding agreement
- Content changes to Trust modification order
- Content changes to Direction to transfer
- Content changes to Church supplemental agreement
- Update content on Handover to regional delivery officer
- Update content on external stakeholder kick-off
- Update content on process conversion grant
- Complete and approve Single worksheet Task becomes Complete and send Single
  worksheet as a caseworker does not approve the document
- Check the baseline task guidance now refers to this project, not all projects

## [Release 6][release-6]

### Added

- Users can add, edit, and delete task level notes. These are displayed on the
  task page.
- Added a privacy notice and link to the notice in the footer
- Pagination has been added to the projects index page. 10 projects are shown
  per page.

### Changed

- Complete the final checklist with external stakeholder becomes Confirm the
  school has completed all actions. Also update the copy.
- Content updates to Check the baseline
- Content changes to Complete and send the single worksheet
- Content changes for all conditions met
- Rename redact task to be Redact and send funding agreement documents and
  update content
- ESFA final checks and handover becomes Update ESFA data in KIM, also change
  copy.
- Content updates to Confirm opening date with the school.
- Copy changes to conversion grant task
  - Change title from "complete processing of conversion grant" to "Receive
    grant payment certificate"
  - Update the content, hints and guidance
- Supplemental funding agreement now has sign and seal actions.
- Clear legal documents becomes Clear and sign legal documents.
- Only project level notes are shown on the notes page.
- The back link destination is the task page for task level notes, or the notes
  page for project level notes.
- Moved task notes to a more pleasing vertical alignment
- The styling of the projects index summary component is fully responsive.

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
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-82...HEAD
[release-82]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-81...release-82
[release-81]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-80...release-81
[release-80]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-79...release-80
[release-79]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-78...release-79
[release-78]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-77...release-78
[release-77]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-76...release-77
[release-76]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-75...release-76
[release-75]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-74...release-75
[release-74]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-73...release-74
[release-73]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-72...release-73
[release-72]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-71...release-72
[release-71]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-70...release-71
[release-70]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-69...release-70
[release-69]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-68...release-69
[release-68]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-67...release-68
[release-67]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-66...release-67
[release-66]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-65...release-66
[release-65]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-64...release-65
[release-64]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-63...release-64
[release-63]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-62...release-63
[release-62]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-61...release-62
[release-61]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-60...release-61
[release-60]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-59...release-60
[release-59]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-58...release-59
[release-58]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-57...release-58
[release-57]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-56...release-57
[release-56]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-55...release-56
[release-55]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-54...release-55
[release-54]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-53...release-54
[release-53]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-52...release-53
[release-52]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-51...release-52
[release-51]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-50...release-51
[release-50]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-49...release-50
[release-49]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-48...release-49
[release-48]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-47...release-48
[release-47]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-46...release-47
[release-46]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-45...release-46
[release-45]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-44...release-45
[release-44]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-43...release-44
[release-43]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-42...release-43
[release-42]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-41...release-42
[release-41]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-40...release-41
[release-40]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-39...release-40
[release-39]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-38...release-39
[release-38]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-37...release-38
[release-37]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-36...release-37
[release-36]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-35...release-36
[release-35]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-34...release-35
[release-34]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-33...release-34
[release-33]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-32...release-33
[release-32]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-31...release-32
[release-31]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-30...release-31
[release-30]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-29...release-30
[release-29]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-28...release-29
[release-28]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-27...release-28
[release-27]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-26...release-27
[release-26]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-25...release-26
[release-25]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-24...release-25
[release-24]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-23...release-24
[release-23]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-22...release-23
[release-22]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-21...release-22
[release-21]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-20...release-21
[release-20]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-19...release-20
[release-19]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-18...release-19
[release-18]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-17...release-18
[release-17]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-16...release-17
[release-16]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-15...release-16
[release-15]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-14...release-15
[release-14]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-13...release-14
[release-13]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-12...release-13
[release-12]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-11...release-12
[release-11]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-10...release-11
[release-10]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-9...release-10
[release-9]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-8...release-9
[release-8]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-7...release-8
[release-7]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-6...release-7
[release-6]:
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-5...release-6
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
