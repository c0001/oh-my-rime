#!/usr/bin/env bash
set -e
# See https://stackoverflow.com/a/246128/3561275
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

declare ehome_grammer_dir="${DIR%/}/ehome.grammer"

declare -A ehome_grammer_list=(
    ["wanxiang-lts-zh-hans.gram"]="https://github.com/amzxyz/rime_wanxiang/releases/download/v6.0/wanxiang-lts-zh-hans.gram"
)

_job ()
{
    echo -e "\e[32mjob:\e[0m $* \e[32m...\e[0m"
}
_job_1 () {
    echo -e "\e[32m>>>>>>\e[0m $* \e[32m...\e[0m"
}
_err () {
    echo -e "\e[31merr:\e[0m $*" ; exit 1
}

_job 'downloading grammers'
for i in "${!ehome_grammer_list[@]}" ; do
    _job_1 "$i"
    j="${ehome_grammer_list["${i}"]}"
    k="${ehome_grammer_dir%/}/$i"
    if [[ -f $k ]] ; then rm -v "$k" ; fi
    curl -L "$j" -o "$k"
done
