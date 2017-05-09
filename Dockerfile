FROM dtheus/rails:4.2-jessie

ENV RAILS_ENV production
ENV BUNDLE_WITHOUT test:development
ENV PATH $RBENV_ROOT/shims/:$PATH

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN rbenv exec bundle install

ADD . $HOME/app/
USER root
RUN mkdir -p $HOME/app/public/uploads
RUN chown -R web $HOME/app
RUN chown -R web $HOME/app/public/uploads
USER web
WORKDIR $HOME/app/
RUN bundle exec rake assets:clobber; bundle exec rake tmp:clear; bundle exec rake assets:precompile

CMD bundle exec rails s --pid=/tmp/rails.pid
