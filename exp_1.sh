#!/bin/bash
DURATION=600
FLSNUM=1
CMPNUM=4
CMASK=(16 48 112 240)
FMASK=2
IMASK=1
STATS_INTERVAL_SECONDS=1
for VALUESIZE in 1024 4096
do
	for((cmp=1;cmp<=$CMPNUM;cmp+=1))
	do
	resfile="${cmp}-${VALUESIZE}"
	printf "$DURATION $VALUESIZE $cmp ${CMASK[$(expr $cmp-1)]}\n"
	./db_bench --benchmarks="fillrandom,stats" \
		-duration="$DURATION" \
		-value_size="$VALUESIZE" \
		-max_background_flushes="$FLSNUM" \
		-max_background_compactions="$cmp" \
		-compaction_cpuset="${CMASK[$(expr $cmp - 1)]}" \
		-flush_cpuset="$FMASK" \
		-io_cpuset="$IMASK" \
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res/"${resfile}-type1.txt" 2> ../res/"${resfile}-type1-err.txt"

	sleep 300

	./db_bench --benchmarks="fillrandom,stats" \
		-duration="$DURATION" \
		-value_size="$VALUESIZE" \
		-max_background_flushes="$FLSNUM" \
		-max_background_compactions="$cmp" \
		-compaction_cpuset="16" \
		-flush_cpuset="$FMASK" \
		-io_cpuset="$IMASK" \
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res/"${resfile}-type2.txt" 2> ../res/"${resfile}-type2-err.txt"

	sleep 300
	done
done
