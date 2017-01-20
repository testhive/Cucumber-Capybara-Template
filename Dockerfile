FROM ruby:2.2.2

RUN mkdir /app
WORKDIR /app
RUN gem update

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

RUN apt-get update && apt-get install -y --fix-missing iceweasel xvfb

ENV   GECKODRIVER_VERSION v0.13.0
RUN   mkdir -p /opt/geckodriver_folder
RUN   wget -O /tmp/geckodriver_linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz
RUN   tar xf /tmp/geckodriver_linux64.tar.gz -C /opt/geckodriver_folder
RUN   rm /tmp/geckodriver_linux64.tar.gz
RUN   chmod +x /opt/geckodriver_folder/geckodriver
RUN   ln -fs /opt/geckodriver_folder/geckodriver /usr/local/bin/geckodriver

ADD features /app/features

ADD cucumber-command.sh /app/cucumber-command.sh
RUN chmod a+x /app/cucumber-command.sh

CMD xvfb-run --server-args="-screen 0 1440x900x24" bash cucumber-command.sh

# ADD run.sh /run.sh
# RUN chmod a+x /run.sh
# CMD /run.sh
# ENTRYPOINT Xvfb :99 -screen 0 1440x900x24 &
# CMD xvfb-run --server-args="-screen 0 1440x900x24" cucumber features --format pretty --format html --out docker-html-report.html
# CMD ["/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x24"]
