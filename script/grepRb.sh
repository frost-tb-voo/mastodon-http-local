#!/bin/sh

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

M_HOME=/opt/mastodon
APP=${M_HOME}/app
CONFIG=${M_HOME}/config
LIB=${M_HOME}/lib
# GFINGER=${M_HOME}/vendor/bundle/ruby/2.6.0/gems/goldfinger-2.1.1
# OSTATUS=${M_HOME}/vendor/bundle/ruby/2.6.0/gems/ostatus2-2.0.3

# echo "ls ${M_HOME}/vendor/bundle/ruby/2.6.0/gems/" >> temp/find.sh

mkdir -p tmp
echo "rm -f /tmp/log" >> tmp/find.sh
echo "echo 'GREP for https +*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+'" >> tmp/find.sh
echo "find ${M_HOME} \
      -type d -name 'vendor' -prune -or \
      -type d -name 'spec' -prune -or \
      -type f -name '*.rb' -print \
      | xargs grep 'https' >> /tmp/log" >> tmp/find.sh
echo "cat /tmp/log | \
      grep -v 'http https' | \
      grep -v 'https?' | \
      grep -v \"'http://', 'https://'\" | \
      grep -v -P 'https://[a-z]+.*'" >> tmp/find.sh

echo "rm -f /tmp/log" >> tmp/find.sh
echo "echo 'GREP for LOCAL_HTTPS +*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+'" >> tmp/find.sh
echo "find ${M_HOME} \
      -type d -name 'vendor' -prune -or \
      -type d -name 'spec' -prune -or \
      -type f -name '*.rb' -print \
      | xargs grep 'LOCAL_HTTPS' >> /tmp/log" >> tmp/find.sh
echo "cat /tmp/log | \
      grep -v 'http https' | \
      grep -v 'https?' | \
      grep -v \"'http://', 'https://'\" | \
      grep -v -P 'https://[a-z]+.*'" >> tmp/find.sh

docker pull tootsuite/mastodon
docker run --rm -it \
 -v `pwd`/tmp:/temp:rw \
 tootsuite/mastodon \
 bash /temp/find.sh

rm -r tmp

