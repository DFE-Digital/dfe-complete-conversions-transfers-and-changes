#!/bin/bash

echo "Updating RubyGems..."
gem update --system

echo "Seting up application..."
script/initial_setup

echo "Done!"