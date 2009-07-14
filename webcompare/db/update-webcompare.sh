#!/bin/bash

# PATH to the directory that has webcompare-db.exe
WCDB=YOUNEEDAPATHHERE


######################################
cd "${WCDB}" || exit 1

TOKEN_FILE="../binary/1.0/mscorlib.dll"
STAMP_FILE="../binary/webdb.stamp"
LOG_FILE="../binary/webdb.log"
LOCK_FILE="../binary/webdb.lock"

lockfile -l 120 ${LOCK_FILE}
if [ $? -ne 0 ] ; then
	echo "lockfile timed out" >> ${LOG_FILE}
	exit 1
fi

if [ ! -f ${STAMP_FILE} -o ${TOKEN_FILE} -nt ${STAMP_FILE} ] ; then
	touch -r ${TOKEN_FILE} ${STAMP_FILE}
	date > ${LOG_FILE}
	nice -20 mono webcompare-db.exe >> ${LOG_FILE} 2>&1
	date >> ${LOG_FILE}
else
	D=$(date)
	echo "${D}: nothing to update" > ${LOG_FILE}
fi
rm -f ${LOCK_FILE}
exit 0

