#!/bin/bash

set -Eeuo pipefail

declare -A BENCH_DIRS=(
  [basicmath]="automotive/basicmath"
  [bitcount]="automotive/bitcount"
  [qsort]="automotive/qsort"
  [susan]="automotive/susan"
  [blowfish]="security/blowfish"
  [rijndael]="security/rijndael"
  [sha]="security/sha"
  [dijkstra]="network/dijkstra"
  [patricia]="network/patricia"
  [adpcm]="telecomm/adpcm"
  [crc]="telecomm/CRC32"
  [FFT]="telecomm/FFT"
  [gsm]="telecomm/gsm"
)

# 명령어 매핑
declare -A BENCH_CMDS=(
  [basicmath]="./basicmath_large"
  [bitcount]="./bitcnts 1125000"
  [qsort]="./qsort_large input_large.dat"
  [susan]="./susan input_large.pgm output_large.smoothing.pgm -s"
  [blowfish]="./bf e input_large.asc output_large.enc 1234567890abcdeffedcba0987654321"
  [rijndael]="./rijndael input_large.asc output_large.enc e 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321"
  [sha]="./sha input_large.asc"
  [dijkstra]="./dijkstra_large input.dat"
  [patricia]="./patricia large.udp"
  [adpcm]="./bin/rawcaudio < data/large.pcm > output_large.adpc"
  [crc]="./crc ../adpcm/data/large.pcm"
  [FFT]="./fft 8 32768"
  [gsm]="./bin/toast -fps -c data/large.au > output_large.encode.gsm"
)

# 로그 저장 위치
LOG_DIR="./benchmark_logs"
mkdir -p "$LOG_DIR"

# ====== 함수 ======
run_benchmark() {
  local name="$1"

  # 존재 확인
  if [[ -z "${BENCH_DIRS[$name]:-}" ]]; then
    echo " Unknown benchmark: $name"
    return 1
  fi

  local dir="${BENCH_DIRS[$name]}"
  local cmd="${BENCH_CMDS[$name]}"
  local log_file="${LOG_DIR}/${name}.log"

  echo "=============================="
  echo " Running benchmark: $name"
  echo " Directory: $dir"
  echo " Command: $cmd"
  echo "=============================="

  if [[ ! -d "$dir" ]]; then
    echo " Directory not found: $dir"
    return 1
  fi

  cd "$dir"
  start_time=$(date +%s)
  eval $cmd
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  cd - >/dev/null

  echo " Duration: ${duration}s"
  echo
}

# ====== 실행 로직 ======
if [[ $# -eq 0 ]]; then
  # 인자가 없으면 모든 benchmark 실행
  echo " Running all benchmarks..."
  for name in "${!BENCH_DIRS[@]}"; do
    run_benchmark "$name"
  done
else
  # 인자로 받은 benchmark만 실행
  for name in "$@"; do
    run_benchmark "$name"
  done
fi

echo " All done. Logs in: $LOG_DIR"