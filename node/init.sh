#!/bin/bash

tag="mainnet-1.1.6"

current_user=$(whoami)
current_home=$(cd `dirname $0`;pwd)
work_home=$(cd ${current_home};cd ../;pwd)
get_config="${work_home}/config/config.sh"
build_command="${current_home}/build.sh"

eos_home=$(${get_config} "eos_home")
command_dir="${eos_home}/command"
data_dir="${eos_home}/data"
log_dir="${eos_home}/logs"
config_dir="${eos_home}/config"

init_folder() {
    [ ! -d ${eos_home} ] && sudo mkdir -p ${eos_home} && sudo chown ${current_user} ${eos_home}
    [ ! -d ${command_dir} ] && mkdir -p ${command_dir}
    [ ! -d ${log_dir} ] && mkdir -p ${log_dir}
    [ ! -d ${data_dir} ] && mkdir -p ${data_dir}
    [ ! -d ${config_dir} ] && mkdir -p ${config_dir}
}

init_config() {
    cp ${current_home}/config/config.ini ${config_dir}/
    cp ${current_home}/config/genesis.json ${config_dir}/
}

get_code() {
    cd ${eos_home}
    git clone https://github.com/EOS-Mainnet/eos.git
    ${build_command} ${tag}
}

main() {
  init_folder
  init_config
  get_code
}

main