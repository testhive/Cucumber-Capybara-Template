# Cucumber-Capybara-Template
This repository serves as a compact collection of several features for your tests.

There are 4 main components:
* Parallel dockerized run of features in your regression folder with Chrome
* Parallel dockerized run of features in your regression folder with Firefox
* Dockerized security checks with OWASP ZAP for your regression folder
* Dockerized performance tests with Gatling for your performance folder

Requirements:
-------------
* To Run docker runners: Just have docker installed and run the relevant .sh file (docker-parallel-run, docker-parallel-run-firefox, docker-security-run or docker-gatling-run)
* To run individual feature files locally: Have Ruby installed on your machine and do a bundle install, make sure that your ruby version matches the ruby version in your project Gemfile. I recommend using RVM for Linux and MacOS, for Windows follow instructions on https://rubyinstaller.org/ Once Ruby installation and bundle install is complete you can run the command

```cucumber <feature_file> [BROWSER=<browser>]```

Browser is optional, which can be chrome, firefox, headless-chrome, headless-firefox. The default browser is Chrome.
Also, as in any Webdriver based test suite, you'll have to have [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/) and/or [Geckodriver](https://github.com/mozilla/geckodriver/releases) available in your PATH

Some Features of the test suite:
--------------------------------
* As default, when you're using parallel runners, it will create as many docker containers as the number of feature files under regression folder. Beware of your memory consumption and try to limit the number of feature files in that folder.
* If scenarios in your tests fail the first time, only the failing scenorios will be run for a second time (not whole features), so make sure your scenarios are independent of each other.
* Once your parallel runners are done, they will generate reports in your build folder.
* For running security checks you don't have to do any extra work, just have your feature files written and it will automatically test them and report back the security vulnabilirities.
* For performance runners, write your performance tests in gattling and copy your conf and user-files into relevant directories. At the moment you'll have to name your simulation as RecordedSimulation and execute the performance runner script.
* When you run your tests with specifiying an html output screenshots will be captured in the HTML report when your scenarios fail. You can see the screenshot simply by clicking on the screenshot link in the html. You don't have to manage screenshots in a seperate place.

TODO
----
* Get rid of the static performance test simulation name and get it while running the test
* Introduce a default limit for parallel runs, make it changeable via a command line argument
* Make resolution changeable in docker runs
