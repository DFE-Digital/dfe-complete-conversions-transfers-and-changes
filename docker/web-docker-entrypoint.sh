#!/bin/bash
set -e

# Compile assets
bundle exec rails assets:precompile

# Start Rails server on Port 3000, bound to the default network interface
bundle exec rails s -p 3000 -b '0.0.0.0'
