#!/usr/bin/env bash
rm -rf coverage/merge
bundle exec rspec
bundle exec cucumber
bundle exec rake coverage:merge
tree coverage/merge -a
cat coverage/merge/.last_run.json