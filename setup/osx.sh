#!/bin/bash
set -e

dir="$(dirname "$0")"

source "$dir/osx/generic.sh"

if [[ $# == 0 ]]; then
    usage
    exit
fi

while [ "$1" != "" ]; do
    case $1 in
        -h | --help | help)
            usage
            exit
            ;;

        dry-run)
            DRY_RUN=true
            ;;

        go)
            GO=true
            ;;

        *)
            println "${red}unknown option \"$1\"${no_color}"
            usage
            exit 1
            ;;
    esac
    shift
done

println "${yellow}$x preparing user data${no_color}"
printf "\tcaching user password... [enter password]: "
read -s password
println "\n\t${green}password cached${no_color}"

if [[ $DRY_RUN ]]; then
    println "${yellow}$x running in dry-run mode, no changes will be applied${no_color}"
fi

if [[ $GO ]]; then
    source "$dir/osx/go.sh"
    install_go
fi
