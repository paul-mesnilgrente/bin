#!/bin/bash

function usage {
    echo "USAGE:"
    echo "    ${0} i j"
    echo "DESCRIPTION"
    echo "    i    number of rows"
    echo "    j    number of columns"
}

if [ ${#} -ne 2 ]; then
    usage
    exit 1
fi

gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize $1
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize $2

exit 0
