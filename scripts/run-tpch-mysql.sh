#!/bin/bash
set -e

run() {
CURDIR=$(cd `dirname $0`; pwd)
OUTDIR=$CURDIR/check_answers/$1

if [ ! -d $OUTDIR ]; then
  mkdir -p $OUTDIR
fi

cd $CURDIR
for file in `ls mysql/*.sql`; do
  name=${file%.*}
  name=${name##mysql\/}
  outputfile=$OUTDIR/$name.out
  cnt=`jobs -p | wc -l`
  if [ $cnt -ge "1" ]; then
	for job in `jobs -p`;
    	do
        	wait $job
		break
    	done
  fi
  echo "run $file > $outputfile"
  mysql -u root -D tpch < $file >$outputfile &
done

for job in `jobs -p`;
do
	wait $job
done
}

if [ $# -eq 0 ]; then
	run mysql_r
else
	run $*
fi
