#!/bin/bash

# See:
# https://pagure.io/fedora-infrastructure/issue/8865

proxies_list='proxy01.fedoraproject.org proxy02.fedoraproject.org proxy03.fedoraproject.org proxy04.fedoraproject.org proxy05.fedoraproject.org proxy06.fedoraproject.org proxy09.fedoraproject.org proxy10.fedoraproject.org proxy11.fedoraproject.org proxy12.fedoraproject.org proxy13.fedoraproject.org proxy14.fedoraproject.org proxy30.fedoraproject.org proxy31.fedoraproject.org'

urls_list="https://mirrors.fedoraproject.org/metalink?repo=updates-released-f32&arch=x86_64 https://mirrors.fedoraproject.org/metalink?repo=fedora-32&arch=x86_64"


for proxy in ${proxies_list} ;
do
    for url in ${urls_list} ;
    do
        echo -n "${proxy}: "
        curl --connect-to mirrors.fedoraproject.org:443:${proxy}:443 "${url}" &> /dev/null
        if [[ ${?} -eq 0 ]]; then
            echo "mirror ${url} is working"
        else
            echo "mirror ${url} is not working"
        fi
    done
done
