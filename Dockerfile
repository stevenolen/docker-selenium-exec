FROM alpine:3.2  
MAINTAINER technolengy@gmail.com

RUN apk update && apk --update add ruby ruby-irb ruby-io-console tzdata
RUN apk --update add --virtual build-deps build-base ruby-dev libffi libffi-dev \
    && gem install selenium-webdriver --no-ri --no-rdoc \
    && apk del build-deps

ADD example-script.rb /script.rb

CMD ["ruby", "/script.rb"]