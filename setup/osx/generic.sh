#!/bin/bash

# versions
go_version=1.11

# colors
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
no_color="\033[0m"

# symbols
x="◆"

function println {
    printf "$1\n"
}

function usage {
    println "usage: ./osx.sh [dry-run]"
    println "\tdry-run: \tcommand rehearsal"
    println "\tgo: \t\tgo environment (${yellow}${go_version}${no_color})"
}

