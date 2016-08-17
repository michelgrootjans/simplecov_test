# Testing [SimpleCov](https://github.com/colszowka/simplecov/)

This is test project to evaluate [SimpleCov](https://github.com/colszowka/simplecov/) when merging several coverage reports.

To run the whole suite, just run `./run.sh`

This will do the following:
- clean the coverage directory
- run spec with code coverage and save the results under coverage/rspec
- run cukes with code coverage and save the results under coverage/cucumber
- merge both results and save the results under coverage/merge