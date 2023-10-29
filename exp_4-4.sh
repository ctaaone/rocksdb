#!/bin/bash
# 0.1s 단위 1KB 확인
DURATION=60
INUM=1
IMASK=1
FLSNUM=1
FMASK=2
CMPNUM=1
CMASK=(16)
MSIZE=268435456
STATS_INTERVAL_SECONDS=1
STATS_INTERVAL_DIVISOR=(10)

for SID in ${STATS_INTERVAL_DIVISOR[@]}
do
	for VALUESIZE in 1024
	do
		for((type=1;type<=${#CMASK[*]};type+=1))
		do
		resfile="${VALUESIZE}-${SID}"
		rm -rf /tmp/rocksdbtest-1000/dbbench/
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
			-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
			-stats_interval_divisor="$SID" \
			--statistics > ../res-2/"${resfile}.txt" 2> ../res-2/"${resfile}-err.txt"
			# -level0_slowdown_writes_trigger=36 \
			# -delayed_write_rate=9223372036854775807 \
			# -db_write_buffer_size="$MSIZE" \
			# -write_buffer_size="$MSIZE" \
		sleep 60
		done
	done
done