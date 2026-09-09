#!/usr/bin/env bash
# disk_guard.sh — while any V=9 solver runs: if free space on /home < 40 GB, kill the LARGER run (lex) and delete its proofs.
cd "$(dirname "$0")/.." || exit 1
while pgrep -f "A_K12_V9.cnf" >/dev/null; do
  FREE=$(df -BG /home | awk 'NR==2{gsub("G","",$4); print $4}')
  if [ "$FREE" -lt 40 ]; then
    pid=$(pgrep -f "evidence/A_K12_lex/A_K12_V9.cnf" | head -1)
    if [ -n "$pid" ]; then kill "$pid"; sleep 5; rm -f evidence/A_K12_lex/A_K12_V9.drat evidence/A_K12_lex/A_K12_V9.drat.keep
      echo "$(date '+%Y-%m-%dT%H:%M:%S%:z') disk guard: free=${FREE}G < 40G, killed lex V9 ($pid), proofs removed"; fi
  fi
  sleep 300
done
echo "$(date '+%Y-%m-%dT%H:%M:%S%:z') disk guard: no V9 solver running, exiting"
