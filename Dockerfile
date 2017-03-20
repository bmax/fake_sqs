FROM ruby:2.2.2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD . /usr/src/app
RUN bundle install --system

EXPOSE 4568

ENTRYPOINT ["bin/fake_sqs", "--database", "database.yml"]
