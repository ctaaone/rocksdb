#!/bin/bash
DURATION=300
INUM=1
IMASK=1
FLSNUM=3
FMASK=14
CMPNUM=4
CMASK=(16 240)
STATS_INTERVAL_SECONDS=1
for VALUESIZE in 100
do
	for((type=1;type<=${#CMASK[*]};type+=1))
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
		-level0_slowdown_writes_trigger=36 \
		-delayed_write_rate=9223372036854775807 \
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res/"${resfile}.txt" 2> ../res/"${resfile}-err.txt"

	sleep 10
	done
done
