#!/bin/bash
DURATION=600
INUM=1
IMASK=1
FLSNUM=1
FMASK=4
CMPNUM=2
CMASK=(16 48)
STATS_INTERVAL_SECONDS=1
for VALUESIZE in 1024 4096
do
	for((type=1;type<=2;type+=1))
	do
	resfile="${VALUESIZE}-${type}"
	./db_bench --benchmarks="fillrandom,stats" \
		-duration="$DURATION" \
		-value_size="$VALUESIZE" \
		-max_background_flushes="$FLSNUM" \
		-max_background_compactions="$CMPNUM" \
		-compaction_cpuset="${CMASK[$(expr $type - 1)]}" \
		-flush_cpuset="$FMASK" \
		-threads="$INUM" \
		-io_cpuset="$IMASK" \
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res/"${resfile}.txt" 2> ../res/"${resfile}-err.txt"

	sleep 300
	done
done
