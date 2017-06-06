#!/bin/bash
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/config.inc
export JAVACMD=$GRAAL_CORE_CMD
exec $SCRIPT_PATH/TruffleSqueak/trufflesqueak.sh $@
