#!/usr/bin/env bash
# https://pinyin.sogou.com/dict/detail/index/4
_this_srcfpath="${BASH_SOURCE[0]}"
while [ -h "$_this_srcfpath" ]; do # resolve $_this_srcfpath until the file is no longer a symlink
    _this_srcdirpath="$( cd -P "$( dirname "$_this_srcfpath" )" >/dev/null && pwd )"
    _this_srcfpath="$(readlink "$_this_srcfpath")"

    # if $_this_srcfpath was a relative symlink, we need to resolve it relative
    # to the path where the symlink file was located
    [[ $_this_srcfpath != /* ]] && _this_srcfpath="$_this_srcdirpath/$_this_srcfpath"
done
_this_srcdirpath="$( cd -P "$( dirname "$_this_srcfpath" )" >/dev/null && pwd )"

set -e

for i in imewlconverter jq curl
do
    command -v $i
done
_this_name='zhNetPopulationDict'
_this_url='https://pinyin.sogou.com/d/dict/download_cell.php?id=4&name=%E7%BD%91%E7%BB%9C%E6%B5%81%E8%A1%8C%E6%96%B0%E8%AF%8D&f=detail'
_this_type='scel'
_this_head="---
name: $_this_name
version: \"$(printf '%(%Y-%m-%d)T')\"
sort: by_weight
..."

_this_dictfname="${_this_name}.dict.yaml"
_this_dictsrcbin="${_this_name}.scel"
cd "$_this_srcdirpath"
for i in "$_this_dictsrcbin" "$_this_dictfname" ; do
    if [[ -f $i ]] ; then
        rm -v "$i"
    fi
done

curl -L "$_this_url" -o "$_this_dictsrcbin"

imewlconverter -os:linux -i:"${_this_type}" "$_this_dictsrcbin" -o:rime "$_this_dictfname"

_this_val="$(< "$_this_dictfname")"
printf "%s\n%s" "$_this_head" "$_this_val" > "$_this_dictfname"
echo 'done.'
