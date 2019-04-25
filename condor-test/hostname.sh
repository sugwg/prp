#!/bin/bash -v

echo "=================================================" > ${1}
hostname >> ${1}
cat ${2} >> ${1}
echo >> ${1}
echo "=================================================" >> ${1}
ls -l /cvmfs/oasis.opensciencegrid.org/ligo 2>&1 >> ${1}
ls -l /cvmfs/gwosc.osgstorage.org/gwdata/O1/strain.4k/frame.v1/ 2>&1 >> ${1}
ls -l /cvmfs/singularity.opensciencegrid.org/sugwg/ 2>&1 >> ${1}
ls -l /cvmfs/stash.osgstorage.org/user/dbrown/public 2>&1 >> ${1}
echo >> ${1}
echo "=================================================" >> ${1}
env >> ${1}
echo >> ${1}
echo "=================================================" >> ${1}
echo >> ${1}
sleep 5
exit 0
