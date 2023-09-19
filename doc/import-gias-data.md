# Importing GIAS data

The GIAS data made available from the
[Academies API](https://github.com/DFE-Digital/academies-api) is the
[public GIAS public data set](https://get-information-schools.service.gov.uk/Downloads)
and does not contain the converting academy details that our users need to
reference, these only appear in the public dataset once their opening date is
reached, which is too late for our users.

Despite our best efforts and without a suitable GIAS API, we have had to bring
this dataset into our own tables and import it manually. The main reasons for
doing so:

- DfE sign in could not supply a 'machine' account to automate any further,
  accounts must be associated to a real user

It also has other benefits:

- the application is able to search for projects using more parameters
- the overall performance of the application improves if the data is used
  instead of the Academies API

We treat this data as reference data and should always work with the principles:

- all records could be deleted at any time and replaced
- the incoming data takes precedence
- the URN is unique and always available (we believe it acts as the primary
  identifier in GIAS, but this is unconfirmed)
- the data will need updating on a regular basis and Service Support will take
  on this responsibility
- the data is read-only once imported

## About the GIAS dataset

At the time of writing the dataset is ~50k rows.

Because our users need the unpublished records and a specific set of columns,
the default 'download, full set of data' is not enough.

In order to obtain the correct dataset from GIAS a user must:

- have a DfE sign in account
- have appropriate GIAS permissions on that account
- sign in to GIAS
- select 'Find an establishment'
- select 'All establishments'
- do not check 'Include open establishments only'
- click 'Download'
- select 'Choose a specific set of data'
- click 'Continue'
- check all the available options
- select 'Data in CSV format'
- download the resulting file
- unzip the resulting file
- do not open the file

The GIAS data is downloaded as a CSV with `ISO-8859-1` encoding which the
importer will assume, changing the encoding by opening and saving in
applications such as MS Excel is not recommended and may cause the importer to
fail.

## About the importer

The importer assumes the following:

- the URN is unique across the data
- the file is encoded with ISO-8859-1 (not UTF-8)
- the file has the
  [appropriate columns and headers](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/blob/main/app/services/import/gias_establishment_csv_importer.rb)
- the values in the file overwrite those in the database, if they have changed
- all rows are imported regardless of the establishment state or type
- in order to check for updates, the importer has to load each row to compare it
- each row values are compared to those in the database and the row skipped if
  there is no update to make
- running the importer multiple times on the same data will not result in
  duplicates
- we favour the database running multiple queries over loading large amounts of
  data into memory inside the application container

Whilst the importer runs an `upsert` the MS SQL database adapter will rely on
does not support the
[Rails upsert](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-upsert)
method so we have to use a `SELECT` and `UPDATE` to achieve the same thing, this
does mean a new record will result in two transactions, one to create the
initial record with the URN and a second to update the values.

## Running the import

Right now, only a developer can run the importer from the Rails console, this
will change soon once we have been able to validate how running the import on
the full dataset performs in production like environments.

To import:

- obtain the correct file
- open a Rails console
- initialise a new importer with the path to the file:
  `importer = Import::GiasEstablishmentCsvImporterService.new("/path/to/file.csv")`
- run the import: `importer.import!`

Be aware, importing the entire dataset with empty tables will take ~8 minutes
depending on your development platform, subsequent import time will vary based
on the number of records that need to be updated.
