#!/bin/sh
find . -type f -print0 | xargs -0 sha256sum
