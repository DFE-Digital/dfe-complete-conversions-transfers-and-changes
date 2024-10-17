# Running the application with Github Codespaces

If you are not a developer and wish to run the application 
(e.g. a Content Designer, UX) or are using a Windows machine, we recommend
running this application using [Github Codespaces](https://github.com/features/codespaces).

## Prerequisites

You will need a Github account with read/write access to the repository. 

You will also need for your Github account to be granted access to run Codespaces
paid for by DfE Digital. To check if this is the case, click on the green "Code"
button on the repository, and choose the "Codespaces". If you can see "Codespace
usage for this repository is paid for by DFE-Digital." then you have the correct
access.

## Running a Codespace

1. Click on the green "Code" button and choose "Codespaces" from the tabs
1. Click the plus + icon
1. The Codespace will start up in a new tab. Initial setup takes some time, but
   once it has completed the initial setup will not need to run again (unless you
   destroy and rebuild the Codespace)
1. Once it has built you will be able to view the codebase in a virtual VS Code IDE 
   running in your browser. If you wish to use another IDE, some others offer bridges
   to connect to Codespaces, for example [JetBrains](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-your-jetbrains-ide)

The above instructions will create a Codespace on the `main` branch. 

To build a Codespace on a different branch, create a branch on the repository and follow
the same instructions from that branch.

## Post-creation setup

After creating the Codespace, you will need to create a user and seed the database to 
enable yourself to log in and see data. Open a terminal in your IDE and follow the 
instructions in [Seeding the database](/doc/seeding-the-database.md)

You will need to re-do the seeds every time you destroy and rebuild the Codespace, but
*not* if you merely stop and restart the Codespace.

### Logging into the application

After you have created your user, you will need to log in via the "Developer login"
button on the sign in page, using the same email address you used when creating a user
while seeding the database. Input your name and email address in the basic login form.

Unfortunately the Azure AD login does not work when running the application with
Codespaces.
