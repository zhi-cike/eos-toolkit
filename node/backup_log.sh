#!/bin/bash

current_home=$(cd `dirname $0`;pwd)
work_home=$(cd ${current_home};cd ../;pwd)
get_config="${work_home}/config/config.sh"
eos_home=$(${get_config} "eos_home")
backup_days=$(${get_config} "log_backup_days")
log_home="${eos_home}/logs"
logger="python ${work_home}/utils/logger.py"

stdout_log="stdout.txt"
stderr_log="stderr.txt"
suffix=$(date -d '1 days ago' "+%F")

log() {
    ${logger} -m "$@"
}

get_history_log() {
    find ${log_home} -ctime +${backup_days} -type f -wholename "${log_home}/$1_*"
}

clear_history_log() {
    history_log=`get_history_log $1`
    if [ "${history_log}" == "" ];then
        return
    fi
    log "clear history log: ${history_log}"
    find ${log_home} -ctime +${backup_days} -type f -wholename "${log_home}/$1_*" | xargs rm -f
}

backup_log() {
    if [ "" == "$1" ];then
        return
    fi
    clear_history_log $1
    log_file="${log_home}/$1"
    if [ -f "${log_file}" ] && [ -s "${log_file}" ];then
        cp -f ${log_file} "${log_file}_${suffix}"
        > ${log_file}
    fi
}

backup_log ${stderr_log}
backup_log ${stdout_log}
