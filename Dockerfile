FROM dtheus/rails:4.2-jessie

ENV RAILS_ENV production
ENV BUNDLE_WITHOUT test:development

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app/
RUN mkdir -p /app/public/uploads

WORKDIR /app/
RUN env
RUN bundle exec rake assets:clobber; bundle exec rake tmp:clear; bundle exec rake assets:precompile

CMD bundle exec rails s
