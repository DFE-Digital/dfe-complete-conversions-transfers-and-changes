# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased][unreleased]

### Fixed

- Address subtle bug in Project creation, which meant two projects with the same
  URN were created in error
- Notification banner when users email not recognised is no longer a success
  banner.

### Added

- Raise a specific error page if our access to the Academies Api has been
  revoked

### Changed

- Corrected Legal Adviser's Office to Legal Advisors Office in trust
  modification order task checkboxes
- Added new guidance to project creation page so users know to find information
  in the advisory board template
- Updated content in Confirm the school has completed all actions task so that
  it applies to both types of conversion
- Removed the "Tell the Regional Delivery Officer the school has opened" task

## [Release 22][release-22]

### Added

- new MembersApi Client to call the Parliamentary Members API and retrieve MP
  details
- show the Member of Parliament details for a school on a new page

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
  https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/compare/release-22...HEAD
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
