FROM dtheus/rails:4.2-jessie

ENV RAILS_ENV production
ENV BUNDLE_WITHOUT test:development

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD . $HOME/app/
RUN mkdir -p $HOME/app/public/uploads

WORKDIR $HOME/app/
RUN bundle exec rake assets:clobber; bundle exec rake tmp:clear; bundle exec rake assets:precompile

CMD bundle exec rails s
