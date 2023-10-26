#!/bin/bash
# 1,2,3,4개 코어 비교 (CPU Util 총합 및 throughput 비교)
DURATION=1200 # 600 or 1200
INUM=1
IMASK=1
FLSNUM=1
FMASK=2
CMPNUM=4
CMASK=(16 48 112 240)
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
		-stats_interval_seconds="$STATS_INTERVAL_SECONDS" \
		--statistics > ../res-3/"${resfile}.txt" 2> ../res-3/"${resfile}-err.txt"
		# -level0_slowdown_writes_trigger=36 \
		# -delayed_write_rate=9223372036854775807 \
		# -db_write_buffer_size="$MSIZE" \
		# -write_buffer_size="$MSIZE" \

	#rm -rf /tmp/rocksdbtest-1000/dbbench/
	sleep 600
	done
done
