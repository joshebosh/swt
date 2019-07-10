root@fu10:/tmp# less pulluuid.sh
#!/bin/bash

set -e
set -u

PSQL=/usr/bin/psql

DB_USER=fusionpbx
DB_HOST=127.0.0.2
DB_NAME=fusionpbx

$PSQL \
    -X \
    -h $DB_HOST \
    -U $DB_USER \
    -c "SELECT cr.call_recording_uuid, cr.call_recording_name, cr.call_recording_path, x.uuid FROM v_call_recordings AS cr , v_xml_cdr AS x WHERE CAST (cr.call_recording_length AS INTEGER) < '6' AND x.record_name = cr.call_recording_name AND x.destination_number != '911';" \
    --single-transaction \
    --set AUTOCOMMIT=off \
    --set ON_ERROR_STOP=on \
    --no-align \
    -t \
    --field-separator ' ' \
    --quiet \
    -d $DB_NAME \
    | while read cr_uuid name path xml_uuid ; do
	  echo "CR_UUID: $cr_uuid $name $path $xml_uuid"
	  fullpath=$path/$name
	  rm $fullpath
	  psql --host=127.0.0.2 --username=fusionpbx -c "DELETE FROM v_call_recordings WHERE call_recording_uuid = '${cr_uuid}'"
	  
	  psql --host=127.0.0.2 --username=fusionpbx -c "UPDATE v_xml_cdr SET record_name = NULL, record_path = NULL WHERE uuid = '${xml_uuid}'"
      done
