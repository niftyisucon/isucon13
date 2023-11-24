#!/bin/bash

set -e

#./deploy_body.sh 2>&1 | notify_slack
./deploy_body.sh $*

# END
