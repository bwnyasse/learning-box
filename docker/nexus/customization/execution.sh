#!/bin/bash
NEXUS_LOG=/sonatype-work/logs/nexus.log


function wait_for_log_file() {
  while ! tail -f $NEXUS_LOG ; do sleep 1 ; done
}

function wait_for_server() {
  until `tail -F $NEXUS_LOG |  grep --line-buffered 'started'`; do
    sleep 1
  done
}

## Add snapshot repo
function add_snapshot_repo() {
  mv /tmp/snapshots-repo/* /sonatype-work/storage/snapshots/
}

# Wait Nexus to started
echo "=> Starting nexus to start"
/opt/sonatype/nexus/bin/nexus start

#wait_for_log_file

# Wait Nexus to started
#echo "=> Waiting nexus to start"
#wait_for_server


#add_snapshot_repo
