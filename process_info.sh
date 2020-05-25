#!/bin/sh

# cargo run --features no-loop-fix --bin ldap3-unbind-orig
# cargo run --features with-loop-fix --bin ldap3-unbind-fixed
# cargo run --features no-loop-fix --bin ldap3-drop-orig
# cargo run --features with-loop-fix --bin ldap3-drop-fixed

PS_OPTIONS="-o etime,pagein,vsz,rss,%cpu,%mem,command"

LOG_FILE="ldap3_process_info_$(date +%Y%m%d_%Hh%M).log"

ps ${PS_OPTIONS} -p $(pgrep ps) | head -n 1 | tr -s ' ' , | tee -a ${LOG_FILE}

while true; do ps ${PS_OPTIONS} -p $(pgrep ldap3) 2>/dev/null | tail -n 1 | tr -s ' ' ,; done | tee -a ${LOG_FILE}
