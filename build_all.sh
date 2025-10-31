#!/bin/bash

TOP_DIR="$(cd "$(dirname "$0")" && pwd)"

DIRS=(
    "./automotive/basicmath"
    "./automotive/bitcount"
    "./automotive/qsort"
    "./automotive/susan"
    "./network/dijkstra"
    "./network/patricia"
    "./security/blowfish"
    "./security/rijndael"
    "./security/sha"
    "./telecomm/adpcm/src"
    "./telecomm/CRC32"
    "./telecomm/FFT"
    "./telecomm/gsm"
)

LOG_DIR="${TOP_DIR}/build_logs"
mkdir -p "$LOG_DIR"

CLEAN_ONLY=0

usage() {
  cat <<EOF
Usage: $(basename "$0") [--clean-only|-c]
  기본: 각 디렉토리에서 'make clean' 후 'make' 실행
  옵션:
    -c, --clean-only   'make clean'만 실행 (빌드 생략)
    -h, --help         도움말
EOF
}

# 옵션 파싱
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--clean-only) CLEAN_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 2 ;;
  esac
done

echo " Project root: $TOP_DIR"
echo " Targets: ${DIRS[*]}"
echo " Clean-only: ${CLEAN_ONLY}"
echo

failures=()

for rel_path in "${DIRS[@]}"; do
  dir="${TOP_DIR}/${rel_path}"
  log_file="${LOG_DIR}/$(echo "$rel_path" | tr '/ ' '__').log"

  echo "=============================="
  echo " Entering: $rel_path"
  echo "=============================="

  if [[ ! -d "$dir" ]]; then
    echo " Directory not found: $rel_path"
    failures+=("$rel_path (dir missing)")
    echo
    continue
  fi

  cd "$dir"

  if [[ ! -f Makefile ]]; then
    echo " No Makefile in $rel_path"
    cd "$TOP_DIR"
    echo
    continue
  fi

  echo " make clean"
  if ! make clean >> "$log_file" 2>&1; then
    echo " make clean failed in $rel_path (see $log_file)"
    # clean 실패해도 계속 진행
  fi

  if (( CLEAN_ONLY == 0 )); then
    echo " make"
    if ! make >> "$log_file" 2>&1; then
      echo " Build failed in $rel_path (see $log_file)"
      failures+=("$rel_path (build failed)")
    else
      echo "Build success: $rel_path"
    fi
  else
    echo " Clean done: $rel_path"
  fi

  cd "$TOP_DIR"
  echo
done

  if (( CLEAN_ONLY == 1 )); then
    rm -rf $LOG_DIR
  fi


echo "=============================="
if ((${#failures[@]})); then
  echo " Failures (${#failures[@]}):"
  printf ' - %s\n' "${failures[@]}"
  echo " Logs: $LOG_DIR"
  exit 1
else
  echo " All tasks completed."
  echo " Logs: $LOG_DIR"
fi