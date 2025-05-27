#!/bin/bash
set -e

echo "ENTRYPOINT START: initContainer"
bundle exec rails db:prepare
echo "ENTRYPOINT END: initContainer"
