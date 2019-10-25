FROM tootsuite/mastodon

MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/mastodon-http-local"

RUN sed -i -e "s|force_ssl|# force_ssl|g" /opt/mastodon/app/controllers/application_controller.rb

RUN sed -i -e 's|"https://#{record.domain}"|"http://#{record.domain}"|g' /opt/mastodon/app/helpers/admin/action_logs_helper.rb
RUN sed -i -e "s|https://#{attributes['domain']}|http://#{attributes['domain']}|g" /opt/mastodon/app/helpers/admin/action_logs_helper.rb

RUN sed -i -e "s|https =|https = false # https =|g" /opt/mastodon/config/initializers/1_hosts.rb
RUN sed -i -e "s|http#{Rails.configuration.x.use_https ? 's' : ''}|http|g" /opt/mastodon/config/initializers/content_security_policy.rb

RUN sed -i -e "s|https://#{domain}|http://#{domain}|g" /opt/mastodon/lib/mastodon/domains_cli.rb

RUN sed -i -e "s|'https'|'http'|g" /opt/mastodon/vendor/bundle/ruby/2.6.0/gems/goldfinger-2.1.0/lib/goldfinger/client.rb

RUN sed -i -e "s|Rails.env.production?|false|g" /opt/mastodon/app/controllers/application_controller.rb

RUN sed -i -e 's/Rails.env.production? || /false \&\& /g' /opt/mastodon/config/initializers/devise.rb
RUN sed -i -e 's/Rails.env.production? || /false \&\& /g' /opt/mastodon/config/initializers/session_store.rb
RUN sed -i -e 's/Rails.env.production? || /false \&\& /g' /opt/mastodon/config/initializers/1_hosts.rb

# avoid nginx error
RUN sed -i -e "s|config.action_dispatch.x_sendfile_header|# config.action_dispatch.x_sendfile_header|g" /opt/mastodon/config/environments/production.rb

# allow remote followed private IPs
COPY development_rb_suffix /opt/mastodon/
RUN cat /opt/mastodon/development_rb_suffix >> /opt/mastodon/config/environments/production.rb
# RUN wget -O /opt/mastodon/app/lib/request.rb \
#  https://raw.githubusercontent.com/tootsuite/mastodon/58276715be8a7e6b518ebd33cd2d4fd82ae81b2c/app/lib/request.rb
