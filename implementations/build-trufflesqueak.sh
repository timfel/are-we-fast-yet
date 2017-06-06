#!/bin/bash
if [ "$1" = "style" ]
then
  exit 0
fi

set -e # make script fail on first error
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_PATH/script.inc

INFO Build TruffleSqueak

pushd $SCRIPT_PATH
load_submodule TruffleSqueak
cd TruffleSqueak
mx/mx -n sforceimports
mx/mx -n build
popd

INFO Using Squeak to build Benchmarking Image
$SCRIPT_PATH/build-squeak.sh
