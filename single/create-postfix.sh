#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

if [[ -z ${SMTP_HOSTNAME} ]];then
  exit
fi
if [[ -z ${MSTDN_SUBNET} ]];then
  exit
fi
if [[ -z ${USER_EMAIL} ]];then
  exit
fi
if [[ -z ${POSTFIX_IP} ]];then
  exit
fi
if [[ -z ${INSTANCE} ]];then
  exit
fi

MAILNAME=${SMTP_HOSTNAME}
MY_NETWORKS="127.0.0.0/8, 172.0.0.0/8, ${MSTDN_SUBNET}"
ROOT_ALIAS=${USER_EMAIL}
MY_DESTINATION='localhost.localdomain, localhost'

mkdir -p ./${SMTP_HOSTNAME}
cp ../template/smtp-main.cf ./${SMTP_HOSTNAME}/main.cf
echo -n 'mynetworks = ' >> ${SMTP_HOSTNAME}/main.cf
echo ${MY_NETWORKS} >> ${SMTP_HOSTNAME}/main.cf
echo -n 'myhostname = ' >> ${SMTP_HOSTNAME}/main.cf
echo ${SMTP_HOSTNAME} >> ${SMTP_HOSTNAME}/main.cf
# cp ../template/smtp-master-submission.cf ./${SMTP_HOSTNAME}/master.cf

mkdir -p "./${SMTP_HOSTNAME}/log"
mkdir -p "./${SMTP_HOSTNAME}/data"

sudo docker pull tozd/postfix
sudo docker stop "${SMTP_HOSTNAME}" || true
sudo docker rm "${SMTP_HOSTNAME}" || true
sudo docker run --name "${SMTP_HOSTNAME}" -d \
 --hostname "${SMTP_HOSTNAME}" \
 --env MAILNAME --env MY_NETWORKS --env ROOT_ALIAS --env MY_DESTINATION \
 --volume "${DIR}/../${INSTANCE}/${SMTP_HOSTNAME}/main.cf:/etc/postfix/main.cf" \
 --volume "${DIR}/../${INSTANCE}/${SMTP_HOSTNAME}/log:/var/log/postfix" \
 --volume "${DIR}/../${INSTANCE}/${SMTP_HOSTNAME}/data:/var/spool/postfix" \
 tozd/postfix
sudo docker network connect ${INSTANCE}_external_network --ip=${POSTFIX_IP} postfix

sleep 3
MAIL_TEXT=`cat << _EOF_ > mail.txt
To: ${USER_EMAIL}
From: notifications@localhost
Subject: this is a test

hello world!
_EOF_
`
curl -v smtp://${POSTFIX_IP}:25 \
 --mail-from 'notifications@localhost' --mail-rcpt ${USER_EMAIL} -T mail.txt
# cat mail.txt
rm mail.txt
cat ./${SMTP_HOSTNAME}/log/mail.log
