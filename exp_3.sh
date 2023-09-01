#!/bin/bash
DURATION=3600
INUM=1
IMASK=1
FLSNUM=3
FMASK=14
CMPNUM=4
CMASK=(16 240)
MSIZE=268435456
STATS_INTERVAL_SECONDS=1
for VALUESIZE in 1024
do
	for((type=1;type<=${#CMASK[*]};type+=1))
	do
	resfile="${VALUESIZE}-${type}"
	./db_bench --benchmarks="fillrandom,stats" \
		-duration="$DURATION" \
		-num=1000000000000000 \
		-value_size="$VALUESIZE" \
		-max_background_flushes="$FLSNUM" \
		-max_background_compactions="$CMPNUM" \
		-compaction_cpuset="${CMASK[$(expr $type - 1)]}" \
		-flush_cpuset="$FMASK" \
		-threads="$INUM" \
		-io_cpuset="$IMASK" \
		-level0_slowdown_writes_trigger=36 \
		-delayed_write_rate=9223372036854775807 \
		-db_write_buffer_size="$MSIZE" \
		-write_buffer_size="$MSIZE" \
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res/"${resfile}.txt" 2> ../res/"${resfile}-err.txt"

	sleep 600
	done
done
