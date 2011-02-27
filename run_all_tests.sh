#!/bin/sh

# Poor man's runner
#
# for some reason rake test for all gems
# can't load dependent gems
# TODO: use rake task

OLD=`pwd`

rake test

for transport in `ls transports`; do
    echo "Running $transport"
    cd "transports/$transport" && rake test
    cd "$OLD"
done
