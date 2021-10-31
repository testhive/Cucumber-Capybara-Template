FROM ruby:3.0.0

RUN apt-get update && apt-get install -y --fix-missing curl unzip

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

#Configuring the tests to run in the container
RUN mkdir /app
WORKDIR /app
RUN gem update

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

ADD features /app/features
ADD cucumber.yml /app/
ADD results /app/results

#ADD cucumber-command.sh /app/cucumber-command.sh
#RUN chmod a+x /app/cucumber-command.sh
#
#CMD bash cucumber-command.sh

ADD cucumber-command-parallel.sh /app/cucumber-command-parallel.sh
RUN chmod a+x /app/cucumber-command-parallel.sh

CMD bash cucumber-command-parallel.sh