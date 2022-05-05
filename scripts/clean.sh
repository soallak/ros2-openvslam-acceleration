#!/bin/bash

WS=$(realpath $(dirname $0)/../)
DELETES=(acceleration build install log build-* install-*)

for f in "${DELETES[@]}"; do
echo "Deleting: $WS/$f"
rm -rf "${WS:?}/${f:?}"
done
