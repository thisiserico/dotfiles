#!/bin/bash

go_download_address=https://dl.google.com/go/go${go_version}.darwin-amd64.pkg

function install_go {
    println "${yellow}$x installing go version ${go_version}${no_color}"
    validate_go_version

    if [ $DRY_RUN ]; then
        return
    fi

    println "\tdownloading .pkg file..."
    # wget -O go.pkg -q $go_download_address
    # rm -f go.pkg

    echo $password | sudo -S installer -store -pkg go.pkg -target /
    # sudo installer -store -pkg go.pkg -target /
}

function validate_go_version {
    println "\tvalidating go version $go_version..."

    if curl --output /dev/null --silent --head --fail "$go_download_address"; then
        println "\t${green}valid go version ${go_version}${no_color}"
        return
    fi

    println "\t${red}invalid go version ${go_version}${no_color}"
    exit
}

