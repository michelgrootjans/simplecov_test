#!/usr/bin/env bash
rm -rf coverage
bundle exec rspec
bundle exec cucumber
bundle exec rake coverage:merge
tree coverage/merge -a
