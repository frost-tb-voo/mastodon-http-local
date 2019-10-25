#!/bin/sh

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

M_HOME=/opt/mastodon
APP=${M_HOME}/app
CONFIG=${M_HOME}/config
LIB=${M_HOME}/lib
GFINGER=${M_HOME}/vendor/bundle/ruby/2.6.0/gems/goldfinger-2.1.0
OSTATUS=${M_HOME}/vendor/bundle/ruby/2.6.0/gems/ostatus2-2.0.3

mkdir -p temp
# echo "find ${M_HOME} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh
# echo "find ${APP} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh
# echo "find ${CONFIG} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh
# echo "find ${LIB} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh
echo "find ${APP} -type f -print | xargs grep -rn 'https'" >> temp/find.sh
echo "find ${CONFIG} -type f -print | xargs grep -rn 'https'" >> temp/find.sh
echo "find ${LIB} -type f -print | xargs grep -rn 'https'" >> temp/find.sh

echo "find ${GFINGER} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh
echo "find ${OSTATUS} -type f -name "*.rb" -print | xargs grep -rn 'https'" >> temp/find.sh

echo "find ${APP} -type f -name "*.rb" -print | xargs grep -rn 'LOCAL_HTTPS'" >> temp/find.sh
echo "find ${CONFIG} -type f -name "*.rb" -print | xargs grep -rn 'LOCAL_HTTPS'" >> temp/find.sh
echo "find ${LIB} -type f -name "*.rb" -print | xargs grep -rn 'LOCAL_HTTPS'" >> temp/find.sh

sudo docker pull tootsuite/mastodon
sudo docker run --rm -it \
 -v `pwd`/temp:/temp:rw \
 tootsuite/mastodon \
 bash /temp/find.sh

rm -r temp

