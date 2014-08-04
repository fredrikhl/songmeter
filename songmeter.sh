#!/bin/bash
# This script formats output from the AppleScript songstat.scpt
# so that it displays nicely in GeekTool.
# Output from songstat.scpt should be a string formatted as:
#   <artist>|<song>|<percent completed>
# 

# Find our own path
function resolve_symlink  # filename
{
    declare filename="$1" dir
    while [ -h "${filename}" ]; do
        dir="$( cd -P "$( dirname "${filename}" )" && pwd )"
        filename="$(readlink "${filename}")"
        [[ ${filename} != /* ]] && filename="${dir}/${filename}"
    done
    echo ${filename}
}

# Render progress string
function progress  # int parts, int percent, str pre, str post, str space
{
    declare -i parts="$1" percent="$2" count=0
    declare pre="$3" mark="$4" post="$5" sp="$6"

    while [ $count -lt 100 ]; do
        count=$(expr $count + $parts)
        [ $count -lt $percent ] && printf "%b%s" "$pre" "$sp" && continue
        [ $count -lt $(expr $percent + $parts) ] && printf "%b%s" "$mark" "$sp" && continue
        printf "%b%s" "$post" "$sp"
    done
}

# Format output
function formatsong  # data, char
{
    #echo $data
    declare IFS="|"
    declare data=( $1 ) char="$2"

    #echo ${data[0]} # Artist
    #echo ${data[1]} # Song title
    #echo ${data[2]} # Percent completed

    declare a="$(fgcolor white $2)"
    declare b="$(fgcolor red $2)"
    declare c="$(fgcolor black $2)"

    echo "${data[0]}"
    echo "${data[1]}"
    echo $(progress 5 "${data[2]}" "$a" "$b" "$c" "")
}

self_dir=$( dirname $( resolve_symlink ${BASH_SOURCE[0]} ) )

source ${self_dir}/colors.sh

data=`osascript ${self_dir}/songstat.scptd`

if [ -n "$data" ]
then
    formatsong "$data" "•"
    unset data
fi

unset self_dir
