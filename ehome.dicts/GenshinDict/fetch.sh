#!/usr/bin/env bash

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
_this_name='GenshinDict'
_this_url='https://dataset.genshin-dictionary.com/words.json'
_this_lang='zhCN'
_this_head="---
name: $_this_name
version: \"$(printf '%(%Y-%m-%d)T')\"
sort: by_weight
..."

_this_dictfname='GenshinDict.dict.yaml'
_this_dictjson='GenshinDict.data.json'
cd "$_this_srcdirpath"
for i in "$_this_dictjson" "$_this_dictfname" ; do
    if [[ -f $i ]] ; then
        rm -v "$i"
    fi
done

curl -L "$_this_url" -o "$_this_dictjson"
cp -v "$_this_dictjson" "$_this_dictfname"
_this_val="$(jq -r ".[] | .\"${_this_lang}\"" "$_this_dictfname")"
rm -v "$_this_dictfname"

imewlconverter -os:linux -i:word <(printf '%s' "$_this_val") -o:rime "$_this_dictfname"

_this_val="$(< "$_this_dictfname")"
printf "%s\n%s" "$_this_head" "$_this_val" > "$_this_dictfname"
echo 'done.'
