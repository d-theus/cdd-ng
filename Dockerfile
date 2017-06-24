FROM dtheus/rails:4.2-jessie

ENV RAILS_ENV production
ENV BUNDLE_WITHOUT test:development

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app/
RUN mkdir -p /app/public/uploads


# Initializers hack
ARG SECRET_KEY_BASE=216024ccd1e7416560f26edf4888b921605813ce94bba515a6a0401a46def8fdef7b274cdd2066618dd809b4b5d7d710a50a5dc47909fb358e69d5a24ba78f6b
WORKDIR /app/
RUN bundle exec rake assets:clobber; bundle exec rake tmp:clear; bundle exec rake assets:precompile

CMD rm -rf /tmp/rails.pid; bundle exec rails server -P /tmp/rails.pid
