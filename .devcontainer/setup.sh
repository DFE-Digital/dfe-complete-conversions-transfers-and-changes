#! /bin/bash

# set rbenv to use the system (global) Ruby as it will be 3.3.5
rbenv global

# installl gems
bundle install

# install npm packages
yarn

# create databases
bin/rails db:prepare
