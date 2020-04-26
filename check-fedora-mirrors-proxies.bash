#!/bin/bash

# See:
# https://pagure.io/fedora-infrastructure/issue/8865

PROXIES='proxy01.fedoraproject.org proxy02.fedoraproject.org proxy03.fedoraproject.org proxy04.fedoraproject.org proxy05.fedoraproject.org proxy06.fedoraproject.org proxy09.fedoraproject.org proxy10.fedoraproject.org proxy11.fedoraproject.org proxy12.fedoraproject.org proxy13.fedoraproject.org proxy14.fedoraproject.org proxy30.fedoraproject.org proxy31.fedoraproject.org'

URLS="https://mirrors.fedoraproject.org/metalink?repo=updates-released-f32&arch=x86_64 https://mirrors.fedoraproject.org/metalink?repo=fedora-32&arch=x86_64"


for PROXY in ${PROXIES} ;
do
    for URL in ${URLS} ;
    do
        echo -n "${PROXY}: "
        curl --connect-to mirrors.fedoraproject.org:443:${PROXY}:443 "${URL}" &> /dev/null
        if [[ ${?} -eq 0 ]]; then
            echo "mirror ${URL} is working"
        else
            echo "mirror ${URL} is not working"
        fi
    done
done
