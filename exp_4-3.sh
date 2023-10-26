#!/bin/bash
# Compaction 발생 시마다 감소하는 throughput 확인
DURATION=300
INUM=1
IMASK=1
FLSNUM=1
FMASK=2
CMPNUM=1
CMASK=(16)
MSIZE=268435456
STATS_INTERVAL_SECONDS=1
STATS_INTERVAL_DIVISOR=(2 5 10)

for SID in ${STATS_INTERVAL_DIVISOR[@]}
do
	for VALUESIZE in 50 100 200 400
	do
		for((type=1;type<=${#CMASK[*]};type+=1))
		do
		resfile="${VALUESIZE}-${SID}"
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
			--statistics > ../res-4/"${resfile}.txt" 2> ../res-4/"${resfile}-err.txt"
			# -level0_slowdown_writes_trigger=36 \
			# -delayed_write_rate=9223372036854775807 \
			# -db_write_buffer_size="$MSIZE" \
			# -write_buffer_size="$MSIZE" \
		rm -rf /tmp/rocksdbtest-1000/dbbench/
		sleep 300
		done
	done
done